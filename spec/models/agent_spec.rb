# frozen_string_literal: true

require 'rails_helper'

describe Agent do
  # let(:agent) { create(:agent) }
  context 'validates' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(255) }
  end

  context 'associations' do
    it { should have_many(:agent_contract).dependent(:destroy) }
    it { should have_many(:contract).through(:agent_contract) }
  end
end
