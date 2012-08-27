require 'spec_helper'

describe User do
  before(:each) do
    @user = User.new
    @user.email = "test@example.com"
    @user.username = 'test_name'
    #@user.displayname = "test_user_displayname"
    @user.password = "password"
    #@user.password_confirmation = "password_confirmation"
    #@user.firstname = "firstname"
    #@user.lastname = "lastname"
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
    @user1 = User.new
    @user1.username = "test_user_name"
    @user1.should_not be_valid
  end
  it "should require uniqueness email" do
    @user1 = User.new
    @user1.email = "test@example.com"
    @user1.should_not be_valid
  end
  
end