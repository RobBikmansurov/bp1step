# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing agents', type: :feature do
  let(:user) { create :user }

  context 'Finding the list of agents' do
    describe 'any users' do
      it "don't see Agents" do
        visit '/'

        expect(page).not_to have_content('/agents')
        expect(page).to have_content('Войти')
      end
    end

    describe 'logged users' do
      it 'can see Agents' do
        user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
        visit root_path
        click_link 'Войти'
        fill_in :user_username, with: user.email
        fill_in :user_password, with: user.password
        click_button 'Войти'
        expect(page).to have_content('Войти')
        expect(page).to have_content('/agents')
      end
    end
  end
end
