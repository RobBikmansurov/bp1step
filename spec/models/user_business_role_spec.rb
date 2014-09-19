require 'spec_helper'

PublicActivity.enabled = false

describe UserBusinessRole do
  before(:each) do
    @ur = UserBusinessRole.new
    @ur.user_id = 1
    @ur.business_role_id = 1
  end

  it "should be valid" do
   expect(@ur).to be_valid
  end
  it "should require user_id" do
    @ur.user_id = nil
    expect(@ur).not_to be_valid
  end
  it "should require business_role_id" do
    @ur.business_role_id = nil
    expect(@ur).not_to be_valid
  end
end
