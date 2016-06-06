require 'rails_helper'

describe 'Admin Page', type: :feature do
  before(:each) do
    create(:user)
    visit(new_user_session_path)
    fill_in('Username', with: 'jnsoo')
    fill_in('Password', with: 'password')
    click_button("Log in")
    click_link('JN Soo')
  end
  
  
  it { expect(page).to have_content("Orders") }
  it { expect(page).to have_content("Products") }
  it { expect(page).to have_content("Users") }
  it { expect(page).to have_content("Product Categories") }
  it { expect(page).to have_content("Edit Account") }
  
  describe 'click orders' do
    it 'redirects to orders page' do
      click_link('Orders')
      expect(page).to have_current_path orders_path
    end
  end
  
  describe 'click products' do
    it 'redirects to products page' do
      click_link('Products')
      expect(page).to have_current_path products_path
    end
  end
  
  describe 'click Users' do
    it 'redirects to users page' do
      click_link('Users')
      expect(page).to have_current_path users_path
    end
  end
  
  describe 'click Product Categories' do
    it 'redirects categories page' do
      click_link('Product Categories')
      expect(page).to have_current_path categories_path
    end
  end
  
  describe 'clicks Edit Account' do
    it 'redirects to edit account page' do
      click_link('Edit Account')
      expect(page).to have_current_path('/users/edit')
    end
  end
  
end