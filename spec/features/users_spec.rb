# frozen_string_literal: true
require 'rails_helper'

describe User do
  # let!(:user) { create(:user) }

  context 'As Guest' do
    it 'No Tasks' do
      expect(page).not_to have_link('letters')
    end
  end
end
