require 'rails_helper'

describe AdminController, type: :controller do
  describe 'GET #index' do
    context 'logged in' do
      before(:each) { sign_in create(:user) }
      
      it 'gets number of orders' do
        line_item = [create(:carted_line_item)]
        create(:order, line_items: line_item)
        get :index
        expect(assigns(:total_orders)).to eq(1)
      end
      
      it 'renders the admin page' do
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
end