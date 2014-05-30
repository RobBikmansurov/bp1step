require 'spec_helper'

PublicActivity.enabled = false

describe AgentContract do
  context "associations" do
    it { should belong_to(:agent) }
    it { should belong_to(:contract) }
  end

end
