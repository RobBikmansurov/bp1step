require 'rails_helper'

describe Letter do
 let!(:user) { create(:user) }

  context 'As Guest' do
    it 'do not see Letters' do
      expect(page).not_to have_link('letters')
    end
  end

  context 'As User' do
    it 'do not see Letters' do
      expect(page).to have_link('letters')
    end
  end

end
