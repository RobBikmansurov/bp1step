# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBusinessRole, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create :bproce, user_id: user.id }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:business_role_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:business_role) }
  end

  it 'set user by name' do
    _user = FactoryBot.create :user, displayname: 'Иванов'
    business_role = FactoryBot.create :business_role, bproce_id: bproce.id
    user_business_role = FactoryBot.create :user_business_role, business_role_id: business_role.id
    user_business_role.user_name = 'Иванов'
    expect(user_business_role.user_name).to eq('Иванов')
  end
end
