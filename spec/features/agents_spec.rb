require 'spec_helper'
RSpec.feature 'Managing agents', type: :feature do

  scenario 'Finding the list of agents' do
    visit '/'

    click_link 'Контрагенты'
    #expect(current_path).to eq('/about')

    expect(current_path).to be('/agents')
#    expect(page).to have_content("Войти")
  end
end