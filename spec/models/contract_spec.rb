require 'spec_helper'

PublicActivity.enabled = false

describe Contract do
  context "validates" do
    it { should validate_presence_of(:number) }
    it { should ensure_length_of(:number).is_at_least(1).is_at_most(20) }
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_least(3).is_at_most(50) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:description).is_at_least(8).is_at_most(255) }
    it { should validate_presence_of(:status) }
    it { should ensure_length_of(:status).is_at_least(5).is_at_most(15) }
  end

  context "associations" do
    it { should belong_to(:owner) }
    it { should have_many(:bproce_contract).dependent(:destroy) }
    it { should belong_to(:owner).class_name(:User) }
  end
end
