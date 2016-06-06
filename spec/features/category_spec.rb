require 'rails_helper'

describe 'Category Page', type: :feature do
  before(:each) do
    create(:user)
    create(:category, id: 123, name: 'created_category')
    visit(new_user_session_path)
    fill_in('Username', with: 'jnsoo')
    fill_in('Password', with: 'password')
    click_button("Log in")
    click_link('JN Soo')
    click_link('Product Categories')
  end
  
  it { expect(page).to have_current_path categories_path }
  it { expect(page).to have_content('Category Listing') }
  it { expect(page).to have_content('New Category') }
  
  describe 'adding a category' do
    before(:each) { click_link('New Category') }
    
    it { expect(page).to have_current_path new_category_path }
    
    context 'with correct attributes' do
      it 'redirects to category listing with added category' do
        fill_in("Name", with: 'new_category')
        click_button("create Product Category")
        expect(page).to have_current_path categories_path
        expect(page).to have_content('new_category')
      end
    end
    
    context 'with incorrect attributes' do
      it 're-renders new category page with errors' do
        fill_in("Name", with: '')
        click_button("create Product Category")
        expect(page).to have_content('error')
      end
    end
  end
  
  describe 'options' do
    describe 'edit' do
      before(:each) { click_link('Edit') }
      
      it { expect(page).to have_current_path edit_category_path(123) }
      
      context 'with correct attributes' do
        it 'redirects to category listing with added category' do
          fill_in("Name", with: 'edited_category')
          click_button("edit Product Category")
          expect(page).to have_current_path categories_path
          expect(page).to have_content('edited_category')
        end
      end

      context 'with incorrect attributes' do
        it 're-renders edit category page with errors' do
          fill_in("Name", with: '')
          click_button("edit Product Category")
          expect(page).to have_content('error')
        end
      end
      
    end
    
    describe 'destroy', js: true do
      it 'deletes the requested category' do
        accept_alert do
          click_link("Destroy")
        end
        expect(page).to_not have_content('created_category')
      end
    end
  end
  
  
  
  
end