require 'spec_helper'

describe Agent do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_least(3).is_at_most(255) }
  end

  context "associations" do
    it { should have_many(:agent_contract).dependent(:destroy) }
  end
end
