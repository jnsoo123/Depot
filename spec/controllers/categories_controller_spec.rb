require 'rails_helper'

describe CategoriesController, type: :controller do
  let(:category) { FactoryGirl.create(:category) }
  let(:user) { FactoryGirl.create(:user) }
  
  describe 'GET #index' do
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'gets paginated array of categories' do
        get :index
        expect(assigns(:categories).pluck(:id)).to eq(Category.pluck(:id).first(10))
      end
      
      it 'renders the categories page' do
        get :index
        expect(response).to render_template(:index)
      end
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
      before(:each) { sign_in user }
        
      it 'redirects to categories page' do
        get :show, id: category
        expect(response).to redirect_to categories_path
      end
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
      before(:each) { sign_in user }
      
      it 'gets the requested @category' do
        get :edit, id: category
        expect(assigns(:category)).to eq(category)
      end
      
      it 'renders the :edit template' do
        get :edit, id: category
        expect(response).to render_template(:edit)
      end
    end
    
    context 'logged out' do
      
    end
  end
  
  describe 'POST #create' do
    context 'logged in' do
      
    end
    
    context 'logged out' do
      
    end
  end
  
  describe 'PATCH #update' do
    context 'logged in' do
      
    end
    
    context 'logged out' do
      
    end
  end
  
  describe 'DELETE #destroy' do
    context 'logged in' do
      
    end
    
    context 'logged out' do
      
    end
  end
end