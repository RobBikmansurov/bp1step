# frozen_string_literal: true
require 'rails_helper'

describe Letter do
  let(:letter) { ceate(:letter) }
  let!(:role) { create(:role, name: 'user') }
  let!(:user) { create(:user, email: 'test@mail.ru', password: 'password', role: role.id) }

  context 'When user is not logged' do
    it 'do not see Letters' do
      expect(page).not_to have_link('letters')
    end
  end

  context 'When user logged' do
    it 'can see Letters' do
      login(user.email, user.password)
      p page
      expect(page).to have_link('letters')
    end
  end
end
