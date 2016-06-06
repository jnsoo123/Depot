require 'rails_helper'

describe 'Homepage', type: :feature do
  before(:each) do
    create_list(:product, 15)
    visit('/') 
  end
  
  it { expect(page).to have_content('Your Catalog') }
  it { expect(page).to have_content('Your Cart') }
  it 'has pagination' do
    expect(page).to have_css("div.pagination") 
  end

  it 'should display 5 paginated items in the catalog' do
    expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 5)
  end

  describe 'header links' do
    it { expect(page).to have_link('My Cart Project') }
    it { expect(page).to have_link('Home') }
    it { expect(page).to have_link('Questions') }
    it { expect(page).to have_link('News') }
    it { expect(page).to have_link('Contact Us') }

    describe 'My Cart Project' do
      it 'goes to homepage' do
        click_link("My Cart Project")
        expect(page).to have_current_path store_path
      end
    end

    describe 'Home' do
      it 'goes to homepage' do
        click_link("Home")
        expect(page).to have_current_path store_path
      end
    end
      
    context 'logged out' do
      it { expect(page).to have_button('Login') }
      describe 'Login' do
        it 'goes to login page' do
          click_button("Login")
          expect(page).to have_current_path new_user_session_path
        end
      end
    end
      
    context 'logged in' do
      before(:each) do
        create(:user)
        visit(new_user_session_path)
        fill_in('Username', with: 'jnsoo')
        fill_in('Password', with: 'password')
        click_button('Log in')
      end
        
      it { expect(page).to have_content("JN Soo") }
      it { expect(page).to have_content("Signed in successfully.") }
      it 'should have logout button' do 
        expect(page).to have_css('#header input.btn.btn-danger.pull-right')
      end
      
      describe 'clicks user button' do
        before(:each) do 
          click_link('JN Soo')
        end
        
        it { expect(page).to have_current_path admin_path }
        
      end
    end
  end

  describe 'searching a product' do
    before(:each) do
      create(:category, id: 25, name: 'searched_category1')
      create(:category, id: 26, name: 'searched_category2')
      create(:product, title: 'searched_product1', category_id: 25)
      create(:product, title: 'searched_product2', category_id: 26)
      visit('/')
    end

    context 'with title' do
      it 'returns the correct result' do
        fill_in('search', with: 'searched_product')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 2)
        fill_in('search', with: 'not_existing_product')
        click_button('Search')
        expect(page).to have_content('No Results Found!')
        fill_in('search', with: 'searched_product1')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 1)
        fill_in('search', with: nil)
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 5)
      end
    end

    context 'with category' do
      it 'returns the correct result' do
        select('searched_category1', from: 'category')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 1)
        select('searched_category2', from: 'category')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 1)
        select('All', from: 'category')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 5)
      end
    end

    context 'with title and category' do
      it 'returns the correct result' do
        fill_in('search', with: 'searched_product')
        select('searched_category1', from: 'category')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 1)
        fill_in('search', with: 'searched_product')
        select('searched_category2', from: 'category')
        click_button('Search')
        expect(find('div.store ul.list-group')).to have_selector('li.list-group-item', count: 1)
        fill_in('search', with: 'searched_product1')
        select('searched_category2', from: 'category')
        click_button('Search')
        expect(page).to have_content('No Results Found!')
      end
    end

    context 'when search result is > 5' do
      it 'has pagination' do
        fill_in('search', with: 'title')
        click_button('Search')
        expect(page).to have_selector('div.pagination')
      end
    end

    context 'when search result is <= 5' do
      it 'doesn\'t have pagination' do
        fill_in('search', with: 'searched_product')
        click_button('Search')
        expect(page).to_not have_selector('div.pagination')
      end
    end
  end

  describe 'add to cart', js: true do
    it 'renders the cart' do
      first('div.entry a.btn').click
      expect(page).to have_xpath("//div[@id='cart']//ul[@class='list-group']//li[@id='current_item']")
      first('div.entry a.btn').click
      expect(page.find(:css, "div#cart ul.list-group li#current_item span").text).to eq("2")
      page.all('div.entry a.btn')[1].click
      expect(page).to have_selector('div#cart ul.list-group li.list-group-item', count: 3)
    end

    context 'when + is clicked' do
      it 'adds current product' do
        first('div.entry a.btn').click
        first('div.entry a.btn').click
        page.all('div.entry a.btn')[1].click
        first('form.button_to input.btn[value="+"]').click
        expect(page.find(:css, "div#cart ul.list-group li#current_item span").text).to eq("3")
      end
    end

    context 'when - is clicked' do
      context 'when item > 1' do
        it 'deducts current product' do
          first('div.entry a.btn').click
          first('div.entry a.btn').click
          page.all('div.entry a.btn')[1].click
          first('form.button_to input.btn[value="-"]').click
          expect(page.find(:css, "div#cart ul.list-group li#current_item span").text).to eq("1")
        end
      end

      context 'when item is only 1' do
        it 'clears cart' do
          first('div.entry a.btn').click
          find('form.button_to input.btn[value="-"]').click
          expect(page).to have_content("Your Cart is Empty.")
        end
      end

    end
  end

  describe 'check out' do
    it 'proceed to check out' do
      first('div.entry a.btn').click
      first('div.entry a.btn').click
      page.all('div.entry a.btn')[1].click
      click_button("Checkout")
      expect(page).to have_current_path new_order_path
    end
  end

  describe 'empty cart', js: true do
    it 'empty outs the cart' do
      first('div.entry a.btn').click
      first('div.entry a.btn').click
      page.all('div.entry a.btn')[1].click
      accept_alert do
        click_button("Empty Cart")
      end
      expect(page).to have_content('Your Cart is Empty.')
    end
  end

  describe 'pagination' do
    context 'when next is clicked' do
      it 'goes to next page' do
        find(:css, "div.pagination a.next_page").click
        expect(page).to have_current_path('/search?page=2')
      end
    end

    context 'when prev is clicked' do
      it 'goes to prev page' do
        find(:css, "div.pagination a.next_page").click
        find(:css, "div.pagination a.previous_page").click
        expect(page).to have_current_path('/search?page=1')
      end
    end

    context 'when page number is clicked' do
      it 'goes to the clicked page' do
        find(:css, "div.pagination a", text: '2').click
        expect(page).to have_current_path('/search?page=2')
        find(:css, "div.pagination a", text: '3').click
        expect(page).to have_current_path('/search?page=3')
        find(:css, "div.pagination a", text: '1').click
        expect(page).to have_current_path('/search?page=1')
      end
    end
  end
end
  
