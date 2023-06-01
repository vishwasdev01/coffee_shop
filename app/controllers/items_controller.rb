class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token

	def index
    items = Item.all
    render json: items
  end

  def show
    item = Item.find(params[:id])
    if item.present?
	    render json: item
	  else
	  	render json: {message: "Id not found"}, status: :unprocessable_entity
	  end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :tax_rate, :discount)
  end
end
