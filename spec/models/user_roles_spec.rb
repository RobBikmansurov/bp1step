require 'spec_helper'

describe UserRole do
  before(:each) do
    @ur = UserRole.new
    @ur.user_id = 1
    @ur.role_id = 1
  end

  it "should be valid" do
    @ur.should be_valid
  end
  it "should require user_id" do
    @ur.user_id = nil
    @ur.should_not be_valid
  end
  it "should require role_id" do
    @ur.role_id = nil
    @ur.should_not be_valid
  end

end
