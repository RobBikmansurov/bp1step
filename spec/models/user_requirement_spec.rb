require 'spec_helper'

describe UserRequirement do
  context "validates" do
    it { should validate_presence_of(:requirement) }
    it { should validate_presence_of(:user) }
  end

  context "associations" do
    it { should belong_to(:requirement) }
    it { should belong_to(:user) }
  end
end