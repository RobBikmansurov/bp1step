require 'spec_helper'

PublicActivity.enabled = false

describe AgentContract do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_least(3).is_at_most(255) }
  end

  context "associations" do
    it { should have_many(:agent_contract).dependent(:destroy) }
    it { should belong_to(:contract).class_name(:agent_contract) }
  end
end
