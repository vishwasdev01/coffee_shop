class OrdersController < ApplicationController

  def index
    orders = Order.all
    render json: orders
  end

  def show
    order = find_order_by_id
    if order.present?
      render_order_with_items_and_discount(order)
    else
      render json: { message: "Order not found" }, status: :unprocessable_entity
    end
  end

  def create
    order = build_order
    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update
    order = find_order_by_id
    if order.update(completed: true)
      render json: order
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_name)
  end

  def item_names
    params[:item_names]
  end

  def find_order_by_id
    Order.find_by(id: params[:id])
  end

  def render_order_with_items_and_discount(order)
    items = order.items.map { |item| apply_discount(item) }

    render json: { order: order, items: items }
  end

  def build_order
    order = Order.new(order_params)
    items = []
    total = 0.0

    item_names.each do |name|
      item = Item.find_by(name: name)
      if item.nil?
        order.errors.add(:base, "Item '#{name}' not found.")
        return order
      end

      items << item
      total += calculate_item_total(item)
    end

    order.items << items if items.present?
    order.total = total
    order.completed = false
    order
  end

  def calculate_item_total(item)
    price_with_discount = item.discount ? item.price * (1 - discount_percentage(item) / 100.0) : item.price
    price_with_tax = price_with_discount * (1 + item.tax_rate / 100.0)
    price_with_tax
  end

  def discount_percentage(item)
    item.discount ? 20 : 0  # Example: 20% discount if 'discount' is true, 0% discount otherwise
  end

  def apply_discount(item)
    if item.discount
      discounted_price = item.price * (1 - discount_percentage(item) / 100.0)
      item.as_json.merge(discounted_price: discounted_price, tax_rate: item.tax_rate)
    else
      item.as_json.merge(tax_rate: item.tax_rate)
    end
  end
end
