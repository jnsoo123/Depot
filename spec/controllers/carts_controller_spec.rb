require 'rails_helper'

describe CartsController, type: :controller do
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