# frozen_string_literal: true

require 'rails_helper'

describe BproceContract do
  let(:user) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create :bproce, user_id: user.id }
  let(:agent) { FactoryBot.create :agent }
  let(:owner) { FactoryBot.create :user }
  let(:contract) { FactoryBot.create :contract, agent_id: agent.id, owner_id: owner.id }

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:contract) }
  end

  it 'set bproce by name' do
    bproce_contract = FactoryBot.create :bproce_contract, bproce_id: bproce.id, contract_id: contract.id
    _bproce_new = FactoryBot.create :bproce, user_id: user.id, name: 'BPROCE_NAME'
    bproce_contract.bproce_name = 'BPROCE_NAME'
    expect(bproce_contract.bproce_name).to eq('BPROCE_NAME')
  end
end
