# frozen_string_literal: true

require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'admin searching for a specific user' do
  context 'when logged in as admin' do
    before(:each) do
      admin = FactoryGirl.create(:user)
      login_as(admin, scope: :user)

      user1 = FactoryGirl.create(:user, email: 'foo@foo.com')
      user2 = FactoryGirl.create(:user, email: 'bar@bar.com')
    end

    scenario 'admin searches for a specific user', js: true do
      visit '/'
      page.body.should     have_content 'foo@foo.com'
      page.body.should     have_content 'bar@bar.com'
      fill_in 'Search', with: 'foo'
      page.body.should     have_content 'foo@foo.com'
      page.body.should_not have_content 'bar@bar.com'
    end
  end
end
