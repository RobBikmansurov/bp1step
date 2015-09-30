require 'spec_helper'
RSpec.feature 'Managing terms', type: :feature do

  context "Any users see list of terms and can't update it" do
    it "Any users see Terms" do
      visit '/'
      click_link 'Термины'
      expect(current_path).to eq('/terms')
      expect(page).to have_content("Термины, определения")
    end
    it 'can not update Terms' do
      visit '/'
      click_link 'Термины'
      expect(page).not_to have_content('Добавить')
      expect(page).not_to have_content('Изменить')
      expect(page).not_to have_content('Удалить')
    end
  end

  describe "logged user" do
    #let!(:user) { FactoryGirl.create(:user) }
    it "signs me in" do
      visit '/users/sign_in'
      within("new_user") do
        fill_in 'Email', :with => 'user@example.com'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Sign in'
      expect(page).to have_content 'Success'
    end
    it 'can update Terms' do
      visit '/'
      user = User.last
      login user.email, user.password
      click_link 'Термины'
      expect(page).to have_content('Добавить')
      click_button 'Добавить Термин'
      expect(current_path).to eq('/terms/new')
    end
  end
end