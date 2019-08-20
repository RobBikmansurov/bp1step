# frozen_string_literal: true

require 'rails_helper'

describe Agent do
  # let(:agent) { create(:agent) }
  context 'with validates' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(255) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:agent_contract).dependent(:destroy) }
    it { is_expected.to have_many(:contract).through(:agent_contract) }
  end

  it 'search' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
