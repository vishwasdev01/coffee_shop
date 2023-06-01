class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

	def index
	  orders = Order.all
	  render json: orders
	end

	def show
    order = Order.find_by(id: params[:id])
    if order.present?
	    render json: order.to_json(include: :items)
	  else
	  	render json: {message: "Id not found"}, status: :unprocessable_entity
	  end
	end

  def create
    order = Order.new(order_params)
    item_names = params[:item_names]
    items = []
    total = 0.0
    
    item_names.each do |name|
      item = Item.find_by(name: name)
      if item.nil?
        render json: { error: "Item '#{name}' not found." }, status: :unprocessable_entity
        return
      end
      items << item
      total += item.price
    end
    
    order.items << items if items.present?
    order.total = total
    order.completed = false
    
    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

	def update
	  order = Order.find(params[:id])
	  if order.update(completed: true)
	    render json: order
	  else
	    render json: order.errors, status: :unprocessable_entity
	  end
	end

	private

	def order_params
	  params.require(:order).permit(:customer_name, :total, :completed)
	end

end
