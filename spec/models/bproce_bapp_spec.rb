# frozen_string_literal: true

require 'rails_helper'

describe BproceBapp do
  let(:user)        { FactoryBot.create :user }
  let(:bproce)      { FactoryBot.create :bproce, user_id: user.id, name: 'BPROCE_NAME' }
  let(:bproce_bapp) { FactoryBot.create :bproce_bapp, bproce_id: bproce.id }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:bproce_id) }
    it { is_expected.to validate_presence_of(:bapp_id) }
    it { is_expected.to validate_presence_of(:apurpose) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:bapp) }
  end

  it 'set bproce by name' do
    bproce_bapp.bproce_name = 'BPROCE_NAME'
    expect(bproce_bapp.bproce_name).to eq('BPROCE_NAME')
  end

  it 'set bapp by name' do
    _bapp = FactoryBot.create :bapp, name: 'APP_NAME', description: 'APP_DESCRIPT'
    bproce_bapp.bapp_name = 'APP_NAME'
    expect(bproce_bapp.bapp_name).to eq('APP_DESCRIPT')
  end

  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
