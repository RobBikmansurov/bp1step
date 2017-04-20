# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Managing agents', type: :feature do
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
        user = User.last
        login user.email, user.password
        visit '/agents'
        expect(page).to have_content('/agents')
        expect(page).to have_content('Войти')
      end
    end
  end
end
