# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBusinessRole, type: :model do
  context 'validates' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:business_role_id) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:business_role) }
  end
end
