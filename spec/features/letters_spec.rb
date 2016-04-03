require 'spec_helper'
RSpec.feature 'Managing letters', type: :feature do

  it "opens courses page after login" do
    visit "/"
    expect(page).to have_content "?"
    click_link "?"
    expect(page).to have_content('Легенда')
  end

end
