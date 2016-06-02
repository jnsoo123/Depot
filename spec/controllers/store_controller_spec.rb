require 'rails_helper'

describe StoreController, type: :controller do
  describe "GET #index" do
    context 'when there\'s no search' do
      before :each do
        create :product
        get :index
      end
      
      it { expect(response).to render_template :index }
      it { expect(assigns(:products).pluck(:id)).to eq(Product.pluck(:id)) }
    end
    
    context 'when there\'s no search and no category' do
      before :each do
        create :product
        get :index, { search: '', category: '' }
      end
      
      it { expect(response).to redirect_to store_path }
    end
    
    context 'when there\'s a search with no category' do
      before :each do 
        create :product, title: 'test'
        create :product, title: 'Hehehe', category_id: 2
        get :index, { search: 'test', category: '' }
      end
      
      it { expect(response).to render_template :index }
      it { expect(assigns(:products).pluck(:id)).to eq([Product.find_by(title: 'test').id]) }
    end
    
    context 'when there\'s no search with a category' do
      before :each do 
        create :product, category_id: 1
        create :product, title: 'Hehehe', category_id: 2
        get :index, { search: '', category: 1 }
      end
      
      it { expect(response).to render_template :index }
      it { expect(assigns(:products).pluck(:id)).to eq([Product.find_by(category_id: 1).id]) }
    end
    
    context 'when there\'s a search with a category' do
      before :each do
        create :product, title: 'test', category_id: 1
        create :product, title: 'Hehehe', category_id: 2
        get :index, { search: 'test', category: 1 }
      end
      
      it { expect(response).to render_template :index }
      it { expect(assigns(:products).pluck(:id)).to eq([Product.find_by(title: 'test', category_id: 1).id]) }
    end
    
  end
end