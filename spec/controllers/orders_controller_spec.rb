require 'rails_helper'

describe OrdersController, type: :controller do
  let (:user) { create(:user) }
  let (:order) { create(:order, line_items: [create(:carted_line_item)]) }
  
  describe "GET #index" do
    context 'logged in' do
      before(:each) do
        sign_in user
        line_item = create_list(:carted_line_item,10)
        create_list(:order, 10, line_items: line_item)
        get :index
      end
      
      it 'gets an array of orders' do
        expect(assigns(:orders).pluck(:id)).to eq (Order.pluck(:id).first(10))
      end
      
      it { expect(response).to render_template :index }
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
      before(:each) do
        sign_in user  
        get :show, id: order
      end 
      
      it 'gets the requested order' do
        expect(assigns(:order)).to eq(order)
      end
      
      it { expect(response).to render_template :show }
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        get :show, id: order
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "GET #new" do
    context 'when cart is not empty' do
      it 'should render template matcher "new"' do
        cart = create(:cart, line_items: [create(:carted_line_item)])
        @request.session[:cart_id] = cart.id
        get :new
        expect(response).to render_template :new 
      end
    end
    
    context 'when cart is empty' do
      it 'redirects to homepage' do 
        get :new
        expect(response).to redirect_to store_path
      end
    end
  end
  
  describe "GET #edit" do
    context 'logged in' do
      before(:each) do
        sign_in user
        get :edit, id: order
      end
      
      it 'gets the requested order' do
        expect(assigns(:order)).to eq(order)  
      end
      
      it { expect(response).to render_template :edit }
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        get :edit, id: order
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "POST #create" do
    context 'with valid order attributes' do
      context 'with line_items' do
        let (:valid_with_line_items) { attributes_for(:order, line_items: create(:carted_line_item)) } 
        
        before(:each) do
          create(:product, id: 1, title: 'test')
        end
        
        it 'creates the order' do
          expect { post :create, order: valid_with_line_items }.to change(Order, :count).by(1)
        end
        
        it 'sends an email to the buyer' do
          expect { post :create, order: valid_with_line_items }.to change{ ActionMailer::Base.deliveries.count }.by(1)
        end
        
        it 'redirects to homepage' do
          post :create, order: valid_with_line_items
          expect(response).to redirect_to store_path
        end
      end
      
      context 'without line_items' do
        it 'redirects to homepage' do
          post :create, order: attributes_for(:order)
          expect(response).to redirect_to store_path
        end
      end
    end
    
    context 'with invalid order attributes' do
      it 're-renders the :new page' do
        post :create, order: attributes_for(:invalid_order, line_items: create(:carted_line_item))
        expect(response).to render_template :new
      end
    end
  end
  
  describe "PUT #update" do
    context 'logged in' do
      before(:each) { sign_in user }
      
      context 'with valid order attributes' do
        before(:each) { put :update, id: order, order: attributes_for(:order, name: 'JN Soo', address: 'Caloocan', email: 'jnsoo@gmail.com', pay_type: 'Purchase Order') }
        
        it 'updates the order' do
          order.reload
          expect(order.name).to eq('JN Soo')
          expect(order.address).to eq('Caloocan')
          expect(order.email).to eq('jnsoo@gmail.com')
          expect(order.pay_type).to eq('Purchase Order')
        end
        
        it 'redirects to edited order' do
          expect(response).to redirect_to order.reload
        end
      end
      
      context 'with invalid order attributes' do
        before(:each) { put :update, id: order, order: attributes_for(:invalid_order, line_items: create(:carted_line_item)) }
        
        it 'does not edit the order' do
          order.reload
          expect(order.name).to_not eq('JN Soo')
          expect(order.address).to_not eq('Caloocan')
          expect(order.email).to_not eq('jnsoo@gmail.com')
          expect(order.pay_type).to_not eq('Purchase Order')
        end
        
        it 're-renders the :edit page' do
          expect(response).to render_template :edit
        end
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        put :update, id: order, order: attributes_for(:order, line_items: create(:carted_line_item))
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "DELETE #destroy" do
    before(:each) { @delete_order = create(:order, line_items: [create(:ordered_line_item)])  }
    context 'logged in' do
      before(:each) { sign_in user }
      
      it 'deletes the order' do
        expect { delete :destroy, id: @delete_order }.to change(Order, :count).by(-1)
      end
      
      it 'redirects to order page' do
        delete :destroy, id: @delete_order
        expect(response).to redirect_to orders_path
      end
    end
    
    context 'logged out' do
      it 'redirects to sign in page' do
        delete :destroy, id: @delete_order
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end