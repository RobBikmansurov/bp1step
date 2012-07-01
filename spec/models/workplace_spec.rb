require 'spec_helper'

describe Workplace do
before(:each) do
    @wp = Workplace.new
    @wp.name = "test_workplaces_1"
  end
  
  it "should require name" do
    @wp.name = nil
    @wp.should_not be_valid
  end
end
