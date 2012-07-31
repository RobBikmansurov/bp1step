require 'spec_helper'

describe Workplace do
before(:each) do
    @wp = Workplace.new
    @wp.name = "test_workplaces_1"
    @wp.description = "Workplace description"
    @wp.designation = "Workplace designation"
  end
  
  #  t.string   "designation"
  #  t.string   "name"
  #  t.string   "description"
  # t.boolean  "typical"
  #  t.string   "location"
  it "should be valid" do
    @wp.should be_valid
  end

  it "should require name" do
    @wp.name = nil
    @wp.should_not be_valid
  end
  it "should require uniqueness name" do
    @wp1 = Workplace.new
    @wp1.name = "test_workplaces_1"
    @wp1.should_not be_valid
  end
  it "should require long name" do
    @wp.name = "short"
    @wp.should_not be_valid
  end
  it "should require max lenght name 50" do
    @wp.name = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
    @wp.should_not be_valid
  end
end
