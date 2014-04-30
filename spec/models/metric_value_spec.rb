require 'spec_helper'

describe MetricValue do
  context "validates" do
    it { should validate_presence_of(:value) }
  end
  
  context "associations" do
    it { should belong_to(:metric) }
  end

end
