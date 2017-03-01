# frozen_string_literal: true
require 'rails_helper'

describe AgentContract do
  context 'associations' do
    it { should belong_to(:agent) }
    it { should belong_to(:contract) }
  end
end
