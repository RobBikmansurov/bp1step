# frozen_string_literal: true

require 'rails_helper'

describe UserRole do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:role) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:role) }
  end
end
