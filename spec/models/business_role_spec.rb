require 'spec_helper'

describe BusinessRole do
  before(:each) do
    @business_role = BusinessRole.new
    @business_role.bproce_id = 1
    @business_role.name = 'test_business_role_name'
    @business_role.description = "test_business_role_description"
  end

  it "should be valid" do
    @business_role.should be_valid
  end

  it "should require name" do
    @business_role.name = nil
    @business_role.should_not be_valid
  end
  it "should require uniqueness name" do
    @business_role1 = Role.new
    @business_role1.name = "test_workplaces_1"
    @business_role1.should_not be_valid
  end
  it "should require long name" do
    @business_role.name = "1234"
    @business_role.should_not be_valid
  end
  it "should require max lenght name 50" do
    @business_role.name = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
    @business_role.should_not be_valid
  end
end
