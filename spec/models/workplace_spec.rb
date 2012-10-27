require 'spec_helper'

describe Workplace do
before(:each) do
    @wp = Workplace.new
    @wp.name = "test_workplaces_1"
    @wp.description = "Workplace description"
    @wp.designation = "WorkplaceDesignation"
    @wp.save
  end
  
  #  t.string   "designation"
  #  t.string   "name"
  #  t.string   "description"
  # t.boolean  "typical"
  #  t.string   "location"
  it "should be valid" do
    @wp.should be_valid
  end

  it "should require designation" do
      @wp.designation = nil
      @wp.should_not be_valid
  end

  it "should require uniqueness designation" do
    @wp1 = Workplace.new
    @wp1.designation = "WorkplaceDesignation"
    @wp1.should_not be_valid
  end

  it "should require long Designation" do
    @wp.designation = "short"
    @wp.should_not be_valid
  end

  it "should require max lenght name 50" do
    @wp.designation = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
    @wp.should_not be_valid
  end
end
