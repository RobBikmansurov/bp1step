# frozen_string_literal: true

require 'rails_helper'

describe BusinessRole do
  let(:user)          { FactoryBot.create :user }
  let(:bproce)        { FactoryBot.create :bproce, user_id: user.id, name: 'BPROCE_NAME' }
  let(:business_role) { FactoryBot.create :business_role, bproce_id: bproce.id }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:bproce_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to have_many(:user_business_role).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_business_role) } # приложение относится ко многим процессам
  end

  it 'set bproce by name' do
    business_role.bproce_name = 'BPROCE_NAME'
    expect(business_role.bproce_name).to eq('BPROCE_NAME')
  end
  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
