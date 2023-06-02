require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET #index' do
    it 'returns a JSON response with all orders' do
      order = Order.create(customer_name: "vish")  
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'when the order exists' do
      it 'returns the item' do
        order = Order.create(customer_name: "vish")
        get :show, params: { id: order.id }   
        expect(response).to have_http_status(:ok)
      end
    end
    
    context 'when the item does not exist' do
      it 'returns a JSON response with an error message' do
        get :show, params: { id: 999 }      
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      item1 = Item.create(name: 'Item 1', price: 10.0, tax_rate: 5.0, discount: false)
      let(:params) { { order: { customer_name: "Vish"}, item_names: ["Item 1"] } }
      
      it 'creates a new item' do
        expect(controller).to receive(:authorize_request)
        post :create, params: params
        expect(response).to have_http_status(:created)
      end
    end    

    context 'with invalid parameters' do
      item1 = Item.create(name: 'Item 1', price: 10.0, tax_rate: 5.0, discount: false)
      let(:params) { { order: { customer_name: "Vish"}, item_names: ["A"] } }
      
      it 'returns a JSON response with an error message' do
        expect(controller).to receive(:authorize_request)
        post :create, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
