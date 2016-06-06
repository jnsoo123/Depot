require 'rails_helper'

describe 'Product Page', type: :feature do
  before(:each) do
    create(:user)
    create(:product, id: 123, title: 'product_title', description: 'product_description', image_url: 'product_image.jpg', price: 150, category: create(:category, name: 'category_name'))
    visit(new_user_session_path)
    fill_in('Username', with: 'jnsoo')
    fill_in('Password', with: 'password')
    click_button("Log in")
    click_link('JN Soo')
    click_link('Products')
    
  end
  
  it { expect(page).to have_current_path products_path }
  it { expect(page).to have_content('New Product') }
  it { expect(page).to have_content('product_title') }
  it { expect(page).to have_content('product_description') }
  it { expect(page).to have_content('category_name') }
  
  describe 'adding new product' do
    before(:each) { click_link('New Product') }
    
    it { expect(page).to have_current_path new_product_path }
    
    context 'with correct attributes' do
      it 'redirects to the new product page' do
        fill_in('Title', with: 'new_product_title')
        fill_in('Description', with: 'new_product_description')
        select('category_name', from: 'Category')
        fill_in('Price', with: '100')
        fill_in('Image url', with: 'new_product_image.jpg')
        click_button('create Product')
        expect(page).to have_current_path product_path(124)
        expect(page).to have_content('new_product_title')
      end
    end
    
    context 'with incorrect attributes' do
      it 're-renders new product page with errors' do
         fill_in('Title', with: '')
        fill_in('Description', with: '')
        select('category_name', from: 'Category')
        fill_in('Price', with: '')
        fill_in('Image url', with: 'new_product_image.doc')
        click_button('create Product')
        expect(page).to have_content('errors')
      end
    end
  end
  
  describe 'testing options' do
    describe 'edit' do
      before(:each) { click_link('Edit') }
      
      it { expect(page).to have_current_path edit_product_path(123) }
      it { expect(page).to have_css('#product_title') }
      it { expect(page).to have_css('#product_description') }
      it { expect(page).to have_css('#product_category_id') }
      it { expect(page).to have_css('#product_price') }
      
      describe 'editing product with correct attributes' do
        it 'returns to requested product with edited attributes' do
          fill_in('Title', with: 'edited_product_title')
          fill_in('Description', with: 'edited_product_description')
          fill_in('Price', with: 20)
          fill_in('Image url', with: 'edited_image_url.jpg')
          select('category_name', from: 'Category')
          click_button('edit Product')
        
          expect(page).to have_current_path product_path(123)
          expect(page).to have_content('edited_product_title')
          expect(page).to have_content('edited_product_description')
        end
      end

      describe 'editing product with incorrect attributes' do
        it 're-renders edit page with errors' do
          fill_in('Title', with: '')
          fill_in('Description', with: '')
          fill_in('Price', with: '')
          fill_in('Image url', with: 'edited_image_url.doc')
          select('category_name', from: 'Category')
          click_button('edit Product')
          expect(page).to have_content('errors')
        end
      end
    end
    
    describe 'destroy', js: true do
      it 'deletes the requested product' do
        accept_alert do
          click_link("Destroy")
        end
        expect(page).to_not have_content('product_title')
      end
    end
  end
  
  
end