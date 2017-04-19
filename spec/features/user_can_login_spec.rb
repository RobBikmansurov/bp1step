require 'rails_helper'

feature 'User login' do
  given!(:user) { FactoryGirl.create(:user) }
  
  before(:each) do
    Capybara.reset_sessions!
  end
  
  scenario 'with valid credentions' do
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Войти'
    # expect(page).to have_content(user.email)
    expect(page).to have_content('Выйти')
  end
  
  scenario 'with invalid credentions' do
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'wrong_password'
    click_button 'Войти'
    expect(page.current_url).to eq(new_user_session_url)
  end
end
