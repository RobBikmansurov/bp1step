# frozen_string_literal: true

require 'rails_helper'

describe UserRole do
  context 'validates' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end
end
