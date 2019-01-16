# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBusinessRole, type: :model do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:business_role_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:business_role) }
  end
end
