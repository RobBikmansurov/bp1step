# frozen_string_literal: true
require 'spec_helper'

RSpec.feature 'user visits home page', type: :feature do
  scenario 'not logged in' do
    visit '/'
    expect(page).to have_content('Войти')

    click_link 'Процессы'
    expect(current_path).to eq('/bproces')
    expect(page).to have_content('Каталог Процессов')

    click_link 'Термины'
    expect(current_path).to eq('/terms')
    expect(page).to have_content('Термины, определения')
  end
end
