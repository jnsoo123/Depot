require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }
  
  describe "GET #index" do
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'gets array of users' do
        get :index
        expect(assigns(:users).pluck(:id).sort).to eq(User.pluck(:id).sort)
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
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'assigns the requested user to @user' do
        get :show, id: user
        expect(assigns(:user)).to eq(user)
      end
      
      it 'renders the :show template' do
        get :show, id: user
        expect(response).to render_template(:show)
      end
    end
    
    context 'logged out' do
      it 'redirect to sign in page' do
        get :show, id: user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end