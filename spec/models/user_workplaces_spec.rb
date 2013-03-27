require 'spec_helper'

PublicActivity.enabled = false

describe UserWorkplace do
  before(:each) do
    @uw = UserWorkplace.new
    @uw.user_id = 1
    @uw.workplace_id = 1
  end

  it "should be valid" do
    @uw.should be_valid
  end
  it "should require user_id" do
    @uw.user_id = nil
    @uw.should_not be_valid
  end
  it "should require workplace_id" do
    @uw.workplace_id = nil
    @uw.should_not be_valid
  end

end
