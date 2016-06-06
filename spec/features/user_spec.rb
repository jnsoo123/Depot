require 'rails_helper'

describe 'Sign In Page', type: :feature do
  before(:each) do
    create(:user)
    visit('/users/sign_in?')
  end
  
  it { expect(page).to have_content('Username') }
  it { expect(page).to have_content('Password') }
  it { expect(page).to have_content('Log In') }
  it { expect(page).to have_content('Sign up') }
  it { expect(page).to have_content('Forgot your password?') }
  
  describe 'header links' do
    it { expect(page).to have_link('My Cart Project') }
    it { expect(page).to have_link('Home') }
    it { expect(page).to have_link('Questions') }
    it { expect(page).to have_link('News') }
    it { expect(page).to have_link('Contact Us') }
    it { expect(page).to have_button('Login') }
    
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
    
    describe 'Login' do
      it 'goes to login page' do
        click_button("Login")
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
  
  describe 'logging in' do
    context 'when account is correct' do
      it 'redirects to homepage' do
        fill_in('Username', with: 'jnsoo')
        fill_in('Password', with: 'password')
        click_button('Log in')
        expect(page).to have_current_path store_path
        expect(page).to have_content('Signed in successfully.')
      end
    end
    
    context 'when account is incorrect' do
      it 're-renders sign in page' do
        fill_in('Username', with: 'invalid_username')
        fill_in('Password', with: 'invalid_password')
        click_button('Log in')
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
  
  describe 'signing up' do
    before(:each) do
      click_link('Sign up')
    end
    
    it { expect(page).to have_current_path('/users/sign_up') }
    it { expect(page).to have_content('Username') }
    it { expect(page).to have_content('Name') }
    it { expect(page).to have_content('Email') }
    it { expect(page).to have_content('Password') }
    it { expect(page).to have_content('Password confirmation') }
    
    context 'when signing up with correct attributes' do
      it 'redirects to home page' do
        fill_in("Username", with: 'correct_username')
        fill_in("Name", with: 'correct_name')
        fill_in("Email", with: 'correct@email.com')
        fill_in("Password", with: 'correct_password')
        fill_in("Password confirmation", with: 'correct_password')
        click_button("Sign up")
        expect(page).to have_current_path store_path
      end
    end
    
    context 'when signing up with incorrect attributes' do
      it 're-renders sign up page with errors' do
        fill_in("Username", with: nil)
        fill_in("Name", with: nil)
        fill_in("Email", with: 'incorrectcom')
        fill_in("Password", with: 'incorrect_password')
        fill_in("Password confirmation", with: 'incorrect_password123')
        click_button("Sign up")
        expect(page).to have_content('errors')
      end
    end
  end
  
  describe 'forgot password' do
    it 'renders forgot password page' do
      click_link("Forgot your password?")
      expect(page).to have_content("Forgot your password?")
    end
  end
end

describe 'Users Page', type: :feature do
  before(:each) do
    create(:user)
    visit(new_user_session_path)
    fill_in('Username', with: 'jnsoo')
    fill_in('Password', with: 'password')
    click_button("Log in")
    click_link('JN Soo')
    click_link('Users')
  end
  
  it { expect(page).to have_current_path users_path }
  it { expect(page).to have_content('User Listing') }
end

describe 'Edit User Page', type: :feature do
  before(:each) do
    create(:user)
    visit(new_user_session_path)
    fill_in('Username', with: 'jnsoo')
    fill_in('Password', with: 'password')
    click_button("Log in")
    click_link('JN Soo')
    click_link('Edit Account')
  end
  
  it { expect(page).to have_current_path('/users/edit') }
  
  describe 'edits account' do
    context 'with correct attributes' do
      it 'redirects to homepage with edited user' do
        fill_in('Name', with: 'edited_user_name')
        fill_in('Email', with: 'edited_email@user.com')
        fill_in('Password', with: 'edited_password')
        fill_in('Password confirmation', with: 'edited_password')
        fill_in('Current password', with: 'password')
        click_button("Update")
        expect(page).to have_content('edited_user_name')
      end
    end
    
    context 'with incorrect attributes' do
      it 're-renders edit user page with errors' do
        fill_in('Name', with: '')
        fill_in('Email', with: 'edited_email@.com')
        fill_in('Password', with: 'edited_password')
        fill_in('Password confirmation', with: 'edited_password')
        fill_in('Current password', with: 'password')
        click_button("Update")
        expect(page).to have_content('error')
      end
    end
    
    context 'with incorrect passwords' do
      it 're-renders edit user page with invalid password error' do
        fill_in('Name', with: 'edited_user_name')
        fill_in('Email', with: 'edited_email@user.com')
        fill_in('Password', with: 'edited_password')
        fill_in('Password confirmation', with: 'edited_password')
        fill_in('Current password', with: 'wrong_password')
        click_button("Update")
        expect(page).to have_content('Current password is invalid')
      end
    end
    
    context 'with incorrect password confirmation' do
      it 're-renders edit user page with passwords does not match' do
        fill_in('Name', with: 'edited_user_name')
        fill_in('Email', with: 'edited_email@user.com')
        fill_in('Password', with: 'edited_password')
        fill_in('Password confirmation', with: 'wrong_edited_password')
        fill_in('Current password', with: 'password')
        click_button("Update")
        expect(page).to have_content('Password confirmation doesn\'t match Password')
      end
    end
  end
end

