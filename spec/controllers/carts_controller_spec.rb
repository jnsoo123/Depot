require 'rails_helper'

describe CartsController, type: :controller do
  describe "GET #index" do
    context 'attempt to access cart' do
      it "redirects to homepage" do
        get :index
        expect(response).to redirect_to store_path
      end
    end
  end
  
  describe "GET #show" do
    context 'attempt to access cart#show' do
      it "redirects to homepage" do
        get :show, id: FactoryGirl.create(:cart)
        expect(response).to redirect_to store_path
      end
    end
  end
  
  describe "GET #new" do
    context 'attempt to access cart#new' do
      it "redirects to homepage" do
        get :new
        expect(response).to redirect_to store_path
      end
    end
  end
  
  describe "GET #edit" do
    context 'attempt to access cart#edit' do
      it "redirects to homepage" do
        get :edit, id: FactoryGirl.create(:cart)
        expect(response).to redirect_to store_path
      end
    end
  end
  
#  describe "POST #create" do
#    context 'attempt to access cart#create' do
#      it "redirects to homepage" do
#        post :create, cart: FactoryGirl.attributes_for(:cart)
#        expect(response).to redirect_to store_path
#      end
#    end
#  end
  
#  describe "PATCH #update" do
#    context 'attempts to access cart#update' do
#      it 'redirects to homepage' do
#        @cart = FactoryGirl.create(:cart)
#        patch :update, id: @cart, cart: FactoryGirl.attributes_for(:cart)
#      end
#    end
#  end
#  
  describe "DELETE #destroy" do
    context 'with matching sessions' do
      it 'deletes the cart' do
        cart = FactoryGirl.create(:cart)
        @request.session[:cart_id] = cart.id
        expect { delete :destroy, id: cart }.to change(Cart,:count).by(-1)
      end
    end
    
    context 'with no matching sessions' do
      it 'does not delete the cart' do
        cart = FactoryGirl.create(:cart)
        expect { delete :destroy, id: cart }.to change(Cart,:count).by(0)
      end
    end
  end
end