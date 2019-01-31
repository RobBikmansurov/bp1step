# frozen_string_literal: true

require 'rails_helper'

describe AgentContract do
  context 'with associations' do
    it { is_expected.to belong_to(:agent) }
    it { is_expected.to belong_to(:contract) }
  end
end
