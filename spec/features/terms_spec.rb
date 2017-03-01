# frozen_string_literal: true
require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

RSpec.feature 'Managing terms', type: :feature do
  context "Any users see list of terms and can't update it" do
    it 'see Terms' do
      visit '/'
      click_link 'Термины'
      expect(current_path).to eq('/terms')
      expect(page).to have_content('Термины, определения')
    end
    it 'can not update Terms' do
      visit '/'
      click_link 'Термины'
      expect(page).not_to have_content('Добавить')
      expect(page).not_to have_content('Изменить')
      expect(page).not_to have_content('Удалить')
    end
  end

  describe 'logged user' do
    # let!(:user) { FactoryGirl.create(:user) }
    it 'signs me in' do
      visit '/'
      click_link 'Войти'
      user = User.last
      p user.inspect
      expect(page).to have_content('Представьтесь, пожалуйста:')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Войти'

      expect(page).to have_content 'Вход в систему выполнен.'
    end
    it 'can update Terms' do
      # term = FactoryGirl.create(:term)
      visit '/'
      user = User.first
      login user.email, user.password
      click_link 'Термины'
      expect(page).to have_content('Добавить Термин')
      click_button 'Добавить Термин'
      expect(current_path).to eq('/terms/new')
    end
  end
end
