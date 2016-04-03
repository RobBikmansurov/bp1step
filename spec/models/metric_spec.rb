require 'spec_helper'

describe Metric do
  context "validates" do
    it { should validate_presence_of(:name) }
    #it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(5).is_at_most(50) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:mtype).is_at_most(10) }
    it { should validate_length_of(:mhash).is_at_most(32) }
  end

  context "associations" do
    it { should belong_to(:bproce) }
  end
end
