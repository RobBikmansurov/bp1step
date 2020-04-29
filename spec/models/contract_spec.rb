# frozen_string_literal: true

require 'rails_helper'

describe Contract do
  let(:agent) { FactoryBot.create(:agent, name: 'Oracle') }
  let(:owner) { FactoryBot.create(:user, displayname: 'Bush') }
  let(:payer) { FactoryBot.create(:user, displayname: 'Smith') }
  let(:user) { FactoryBot.create(:user, displayname: 'DisplayName') }
  let(:agent1) { FactoryBot.create(:agent, name: 'AgentName') }
  let(:contract) do
    FactoryBot.create :contract, agent_id: agent.id, owner_id: owner.id,
                                 payer_id: payer.id, number: '100', name: 'Доп.соглашение'
  end
  let!(:parent_contract) { FactoryBot.create(:contract, agent_id: agent1.id, owner_id: user.id, number: '100/1', name: 'Договор') }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_length_of(:number).is_at_least(1).is_at_most(20) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(255) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_least(8).is_at_most(255) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_length_of(:status).is_at_least(5).is_at_most(15) }
    it { is_expected.to validate_length_of(:contract_type).is_at_least(5).is_at_most(30) }
    it { is_expected.to validate_length_of(:contract_place).is_at_most(30) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:parent).class_name('Contract').optional }
    it { is_expected.to belong_to(:owner).class_name('User') }
    it { is_expected.to belong_to(:payer).class_name('User').optional }
    it { is_expected.to belong_to(:agent).class_name('Agent') }
    it { is_expected.to have_many(:bproce_contract).dependent(:destroy) }
    it { is_expected.to have_many(:contract_scan).dependent(:destroy) }
  end

  it 'return owner name' do
    expect(contract.owner_name).to eq('Bush')
  end

  it 'set owner by owner`s name' do
    contract.owner_name = 'DisplayName'
    expect(contract.owner_name).to eq('DisplayName')
  end

  it 'return payer name' do
    expect(contract.payer_name).to eq('Smith')
  end

  it 'set payer by payer`s name' do
    contract.payer_name = 'DisplayName'
    expect(contract.payer_name).to eq('DisplayName')
  end

  it 'return agent name' do
    expect(contract.agent_name).to eq('Oracle')
  end

  it 'set agent by payer`s name' do
    contract.agent_name = 'AgentName'
    expect(contract.agent_name).to eq('AgentName')
  end

  it 'set parent contract by name' do
    contract.parent_name = parent_contract.autoname
    expect(contract.parent_name).to eq(parent_contract.autoname)
  end

  it 'return short name' do
    expect(contract.shortname).to eq('№ 100 Доп.соглашение')
  end

  it 'return short name < 50 chars' do
    contract.name = '1234567890' * 6
    expect(contract.shortname).to eq("№ 100 #{'1234567890' * 5}")
  end

  it 'return auto name' do
    expect(contract.autoname).to eq("##{contract.id} №100 | Доп.соглашение")
  end

  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
