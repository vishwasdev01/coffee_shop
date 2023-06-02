require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe 'GET #index' do
    it 'returns a JSON response with all items' do
      item1 = Item.create(name: 'Item 1', price: 10.0, tax_rate: 5.0, discount: false)
      item2 = Item.create(name: 'Item 2', price: 20.0, tax_rate: 5.0, discount: true)
      
      get :index
      
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'when the item exists' do
      it 'returns the item' do
        item = Item.create(name: 'Item 1', price: 10.0, tax_rate: 5.0, discount: false)
        
        get :show, params: { id: item.id }
        
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
      let(:params) { { item: {  name: 'Item 1', price: 10.0, tax_rate: 5.0, discount: false  } } }
      it 'creates a new item' do
        expect(controller).to receive(:authorize_request)
        post :create, params: params    
        expect(response).to have_http_status(:created)
      end
    end
  end
end
