require 'rails_helper'

describe ProductsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create(:product) }
  
  describe "GET #index" do
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'gets array of products' do
        get :index
        expect(assigns(:products).pluck(:id)).to eq(Product.pluck(:id).first(10))
      end
      
      it 'renders the :index view' do
        get :index
        expect(response).to render_template(:index)
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "GET #show" do
    it 'assigns the requested product to @product' do
      get :show, id: product
      expect(assigns(:product)).to eq(product)
    end
      
    it 'renders the :show template' do
      get :show, id: product
      expect(response).to render_template(:show)
    end
  end
  
  describe "GET #new" do
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'renders the :new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "GET #edit" do
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'assigns the requested product for edit to @product' do
        get :edit, id: product
        expect(assigns(:product)).to eq(product)
      end
      
      it 'renders the :edit template' do
        get :edit, id: product
        expect(assigns(:product)).to render_template(:edit)
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        get :edit, id: product
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "POST #create" do
    context 'logged in' do
      before(:each) do
        sign_in user
        FactoryGirl.create(:product, title: 'test2')
      end
      
      context 'with valid attributes' do
        it 'creates a new product' do
          expect { 
            post :create, product: FactoryGirl.attributes_for(:product)
            }.to change(Product, :count).by(1)
        end
        
        it 'redirects to new product' do
          post :create, product: FactoryGirl.attributes_for(:product)
          expect(response).to redirect_to Product.last
        end
      end
      
      context 'with invalid attributes' do
        it 'does not create a new product' do
          expect {
            post :create, product: FactoryGirl.attributes_for(:invalid_product)  
            }.to_not change(Product, :count)
        end
        
        it 're-renders the :new template' do
          post :create, product: FactoryGirl.attributes_for(:invalid_product)
          expect(response).to render_template(:new)
        end
      end
      
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        post :create, product: FactoryGirl.attributes_for(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "PATCH #update" do
    before(:each) do 
      @product = FactoryGirl.create(:product, title: 'test3', description: 'test3', image_url: 'test3.gif', price: 15, category_id: 2)
      FactoryGirl.create(:category, name: 'test2')
      FactoryGirl.create(:category, name: 'test3')
      FactoryGirl.create(:category, id: 3, name: 'test4')
    end
    
    context 'logged in' do
      before(:each) do
        sign_in user
        FactoryGirl.create(:product, title: 'test2')
      end
      
      context 'with valid attributes' do
        it 'locates the requested @product' do
          put :update, id: @product, product: FactoryGirl.attributes_for(:product)
          expect(assigns(:product)).to eq (@product)
        end
        
        it 'changes the @product\'s attributes' do
          put :update, id: @product, product: FactoryGirl.attributes_for(:product, title: 'test4', description: 'test4', image_url: 'test4.png', price: 14.99, category_id: 3)
          @product.reload
          expect(@product.title).to eq('test4')
          expect(@product.description).to eq('test4')
          expect(@product.image_url).to eq('test4.png')
          expect(@product.price).to eq(14.99)
          expect(@product.category_id).to eq(3)
        end
        
        it 'redirects to updated @product' do
          put :update, id: @product, product: FactoryGirl.attributes_for(:product)
          expect(response).to redirect_to @product
        end
      end
      
      context 'with invalid attributes' do
        it 'locates the requested @product' do
          put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
          expect(assigns(:product)).to eq (@product)
        end
        
        it 'does not change the @product\'s attributes' do
          put :update, id: @product, product: FactoryGirl.attributes_for(:product, title: nil, description: 'test4', image_url: 'test3.doc', price: "asd", category_id: 3)
          @product.reload
          expect(@product.title).to eq('test3')
          expect(@product.description).to_not eq('test4')
          expect(@product.image_url).to eq('test3.gif')
          expect(@product.price).to_not eq('asd')
          expect(@product.category_id).to eq(2)
        end
        
        it 're-renders the edit template' do
          put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
          expect(response).to render_template(:edit)
        end
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "DELETE #destroy" do
    before(:each) { @product = FactoryGirl.create(:product) }
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'deletes the product' do
        expect{ delete :destroy, id: @product }.to change(Product,:count).by(-1)
      end
      
      it 'redirects to products page' do
        delete :destroy, id: @product
        expect(response).to redirect_to products_path
      end
      
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        delete :destroy, id: @product
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end