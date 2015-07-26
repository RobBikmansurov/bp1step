require 'spec_helper'
RSpec.feature 'Managing terms', type: :feature do

  scenario 'Finding the list of terms' do
    visit '/'
    click_link 'Термины'
    expect(current_path).to eq('/terms')
    expect(page).to have_content("Термины, определения")
  end
end