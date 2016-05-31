require 'rails_helper'

describe StoreController, type: :controller do
  describe "GET index" do
    it 'renders the index' do
      get :index
      expect(response).to be_success
    end
  end
  
  describe "POST index" do
    it 'renders the index template with title and category searching' do
      post :index, search: 'ruby', category: 1
      expect(response).to be_success
    end
    
    it 'renders the index template with title searching only' do
      post :index, search: 'ruby', category: nil
      expect(response).to be_success
    end
    
    it 'renders the index template with category searching only' do
      post :index, search: nil, category: 1
      expect(response).to be_success
    end
  end
end