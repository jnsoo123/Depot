require 'rails_helper'

describe CategoriesController, type: :controller do
  let(:category) { create(:category) }
  let(:user) { create(:user) }
  
  describe 'GET #index' do
    context 'logged in' do
      before(:each) do
        sign_in user
        get :index
      end
      
      it 'gets paginated array of categories' do
        expect(assigns(:categories).pluck(:id)).to eq(Category.pluck(:id).first(10))
      end
      
      it { expect(response).to render_template :index }
    end
    
    context 'logged out' do
      it 'redirects to sign up page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'GET #show' do
    context 'logged in' do
      before(:each) do
        sign_in user 
        get :show, id: category
      end
      
      it { expect(response).to redirect_to categories_path }
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        get :show, id: category
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'GET #new' do
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
  
  describe 'GET #edit' do
    context 'logged in' do
      before(:each) do 
        sign_in user 
        get :edit, id: category
      end
      
      it 'gets the requested @category' do
        expect(assigns(:category)).to eq(category)
      end
      
      it { expect(response).to render_template :edit }
    end
    
    context 'logged out' do
      it 'redirects to sign_in page' do
        get :edit, id: category
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'POST #create' do
    context 'logged in' do
      before(:each) { sign_in user }
      
      context 'with valid attributes' do  
        it 'creates a new category' do
          expect { post :create, category: attributes_for(:category) }.to change(Category,:count).by(1)
        end
        
        it 'redirects to category page' do
          post :create, category: attributes_for(:category)
          expect(response).to redirect_to categories_path
        end
      end
      
      context 'with invalid attributes' do
        it 'doesn\'t create a new category' do
          expect { post :create, category: attributes_for(:invalid_category) }.to change(Category,:count).by(0)  
        end
        
        it 're-renders the new page' do
          post :create, category: attributes_for(:invalid_category)
          expect(response).to render_template :new
        end
      end
    end
    
    context 'logged out' do
      it 'redirects to sign up page' do
        post :create, category: attributes_for(:category)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'PATCH #update' do
    context 'logged in' do
      before(:each) do 
        sign_in user
        @category = create :category, name: 'old_name'
      end
      
      context 'with valid attributes' do
        it 'updates the category' do
          put :update, id: @category, category: attributes_for(:category, name: 'new_name')  
          @category.reload
          expect(@category.name).to eq('new_name')
        end
        
        it 'redirects to category page' do
          put :update, id: @category, category: attributes_for(:category)
          expect(response).to redirect_to categories_path
        end
      end
      
      context 'with invalid attributes' do
        before(:each) do
          put :update, id: @category, category: attributes_for(:invalid_category)
          @category.reload
        end
        
        it 'shouldn\'t update the requested category' do
          expect(@category.name).to eq('old_name')
        end
        
        it { expect(response).to render_template :edit }
      end
      
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        put :update, id: create(:category), category: attributes_for(:category)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'logged in' do
      before(:each) do 
        sign_in user
        @category = create(:category)
      end
      
      it 'deletes the chosen product' do
        expect { delete :destroy, id: @category }.to change(Category, :count).by(-1)
      end
      
      it 'redirects to category page' do
        delete :destroy, id: @category
        expect(response).to redirect_to categories_path
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        delete :destroy, id: create(:category)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end