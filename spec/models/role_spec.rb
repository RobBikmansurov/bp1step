require 'spec_helper'

describe Role do
  before(:each) do
    @role = Role.new
    @role.bproce_id = 1
    @role.name = 'test_role_name'
    @role.description = "test_role_description"
  end

  it "should be valid" do
    @role.should be_valid
  end

  it "should require name" do
    @role.name = nil
    @role.should_not be_valid
  end
  it "should require uniqueness name" do
    @role1 = Role.new
    @role1.name = "test_workplaces_1"
    @role1.should_not be_valid
  end
  it "should require long name" do
    @role.name = "1234"
    @role.should_not be_valid
  end
  it "should require max lenght name 50" do
    @role.name = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
    @role.should_not be_valid
  end

end
