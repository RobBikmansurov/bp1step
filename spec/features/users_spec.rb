# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "User Features", type: :feature do
  context 'create new user' do 
    before(:each) do
      visit '/users/sign_in'
      find("form[id='new_user']") do
        fill_in 'user[username]', with: 'john'
        fill_in 'user[password]', with: 'pwd'
      end
    end

    scenario "should be successful" do
      page.should have_css('h2', text: 'Представьтесь, пожалуйста:')
      find("form[id='new_user']") do
        fill_in 'Email', with: 'john.doe@example.com'
      end
      click_button 'Create User'
      expect(page).to have_content 'User was successfully created.'
    end

    scenario "should fail" do
      click_button 'Create User'
      expect(page).to have_content 'Email can\'t be blank'
    end
  end

  context 'update user' do 
    scenario "should be successful" do
      user = User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com')
      visit edit_user_path(user)
      within("form") do
        fill_in 'First name', with: 'Jane'
        fill_in 'Email', with: 'jane.doe@example.com'
      end
      click_button 'Update User'
      expect(page).to have_content 'User was successfully updated.'
      expect(page).to have_content 'jane.doe@example.com'
    end

    scenario "should fail" do
      user = User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com')
      visit edit_user_path(user)
      within("form") do
        fill_in 'First name', with: ''
      end
      click_button 'Update User'
      expect(page).to have_content 'First name can\'t be blank'
    end
  end


  context 'destroy user' do 
    scenario "should be successful" do
      user = User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com')
      visit users_path
      # expect { click_link 'Destroy' }.to change(User, :count).by(-1)
      accept_confirm do
        click_link 'Destroy'
      end
      expect(page).to have_content 'User was successfully destroyed.'
    end
  end
end