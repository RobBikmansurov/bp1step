require 'rails_helper'

describe MetricValue do
  context "validates" do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:dtime) }
  end
  
  context "associations" do
    it { should belong_to(:metric) }
  end

end
