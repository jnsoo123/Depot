require 'rails_helper'

describe 'Order Page', type: :feature do
  before(:each) do
    create(:user)
    visit(new_user_session_path)
    fill_in('Username', with: 'jnsoo')
    fill_in('Password', with: 'password')
    click_button("Log in")
    click_link('JN Soo')
  end
  
  
  
  context 'with no orders' do
    before(:each) { click_link("Orders") }
    
    it { expect(page).to have_current_path orders_path }
    it { expect(page).to have_content('No Orders') }
  end
  
  context 'with orders' do
    before(:each) do
      20.times { create(:order, line_items: [create(:ordered_line_item)]) }
      click_link('Orders')
    end
    
    it { expect(page).to have_current_path orders_path }
    it { expect(page).to_not have_content('No Orders') }
  end
  
  describe 'testing options' do
    before(:each) do
      create(:product, id: 123, title: 'product_title', description: 'product_description', image_url: 'product_image.jpg', price: 10)
      create(:order, id: 123, name: 'order_name', address: 'order_address', email: 'order@email.com', pay_type: 'Check', line_items: [create(:ordered_line_item, product_id: 123 )])
      click_link('Orders')
    end
    
    it { expect(page).to have_content('order_name') }
    it { expect(page).to have_content('order_address') }
    it { expect(page).to have_content('order@email.com') }
    it { expect(page).to have_content('Check') }
    
    describe 'show' do
      before(:each) do
        click_link('Show')
      end
      
      it { expect(page).to have_current_path order_path(123) }
      
      describe 'shows the order details' do
        it { expect(page).to have_content('Order Details') }
        it { expect(page).to have_content('order_name') }
        it { expect(page).to have_content('order_address') }
        it { expect(page).to have_content('order@email.com') }  
        it { expect(page).to have_content('Check') }  
      end
      
      describe 'shows the order list' do
        it { expect(page).to have_content('Order List') }
        it { expect(page).to have_content('product_title') }
        it { expect(page).to have_content('product_description') }
      end
    end
    
    describe 'edit' do
      before(:each) { click_link('Edit') }
      
      it { expect(page).to have_current_path edit_order_path(123) }
      it { expect(page).to have_css('#order_name') }
      it { expect(page).to have_css('#order_address') }
      it { expect(page).to have_css('#order_email') }
      it { expect(page).to have_css('#order_pay_type') }
      
      describe 'editing an order with correct attributes' do
        it 'returns to requested order with edited attributes' do
          fill_in('Name', with: 'edited_order_name')
          fill_in('Address', with: 'edited_order_address')
          fill_in('Email', with: 'edited_order@email.com')
          select('Credit Card', from: 'Pay type')
          click_button('Place Order')
        
          expect(page).to have_current_path order_path(123)
          expect(page).to have_content('edited_order_name')
          expect(page).to have_content('edited_order_address')
          expect(page).to have_content('edited_order@email.com')
          expect(page).to have_content('Credit Card')
        end
      end
      
      describe 'editing an order with incorrect attributes' do
        it 're-renders edit page with errors' do
          fill_in('Name', with: "")
          fill_in('Address', with: "")
          fill_in('Email', with: "")
          select('Credit Card', from: 'Pay type')
          click_button('Place Order')
          expect(page).to have_content('errors')
        end
      end
    end
    
    describe 'destroy', js: true do
      it 'deletes the requested order' do
        accept_alert do
          click_link("Destroy")
        end
        expect(page).to_not have_content('order_name')
      end
    end
  end
  
end