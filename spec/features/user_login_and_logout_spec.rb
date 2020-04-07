# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'User logs in and logs out', type: :feature do
  it 'with correct details', js: true do
    user = create(:user, email: 'someone@example.tld', password: 'somepassword', password_confirmation: 'somepassword')
    p user.inspect

    visit '/'

    click_link 'Войти'
    expect(page).to have_css('h2', text: 'Log in')
    expect(page).to have_current_path(new_user_session_path, ignore_query: true)

    login 'someone@example.tld', 'somepassword'

    expect(page).to have_css('h1', text: 'Welcome to RSpec Rails Examples')
    expect(page).to have_current_path '/'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'Hello, someone@example.tld'

    click_button 'Log out'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Signed out successfully'
    expect(page).not_to have_content 'someone@example.tld'
  end

  it 'locks account after 3 failed attempts' do
    email = 'someone@example.tld'
    # user = create(:user, email: email, password: "somepassword", password_confirmation: "somepassword")

    visit new_user_session_path

    login email, '1st-try-wrong-password'
    expect(page).to have_content 'Неверный e-mail или пароль'

    login email, '2nd-try-wrong-password'
    expect(page).to have_content 'You have one more attempt before your account is locked'

    login email, '3rd-try-wrong-password'
    expect(page).to have_content 'Your account is locked.'
  end
end
