require 'spec_helper'

feature "user visits home page", type: :feature do
  scenario "not logged in" do
    visit '/'

    expect(page).to have_content("Войти")
  end
end