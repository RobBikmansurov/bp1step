require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.build(:user)
    puts @user.username
    puts @user.email
  end
  it "should be valid" do
    @user.should be_valid
  end
  it "should require username" do
    @user.username = nil
    @user.should_not be_valid
  end
  it "should require email" do
    @user.email = nil
    @user.should_not be_valid
  end
  it "should require uniqueness username" do
    @user1 = FactoryGirl.create(:user)
    @user1.should be_valid
    @user1.username = @user.username
    @user1.should_not be_valid
  end
  it "should require uniqueness email" do
    @user1 = FactoryGirl.create(:user)
    @user1.should be_valid
    @user1.email = @user.email
    @user1.should_not be_valid
  end
  it "should hasn't business_roles when new" do
    @user.business_roles.count.should == 0
  end
end