# frozen_string_literal: true

def login(email, password)
  # visit new_user_session_path
  p email, password
  visit root_path
  click_link 'Войти'
  fill_in :user_username, with: email
  fill_in :user_password, with: password
  click_button 'Войти'
end
