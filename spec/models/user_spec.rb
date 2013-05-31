require 'spec_helper'

PublicActivity.enabled = false

describe User do
  before(:each) do
    @user = FactoryGirl.build(:user)
  end
  context 'mass assignment' do
    it { should allow_mass_assignment_of(:username) }
    it { should allow_mass_assignment_of(:email) }
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
    @user1 = build(:user)
    @user1.should be_valid
    @user1.username = @user.username
    @user1.valid?
  end
  it "should hasn't business_roles when new" do
    @user.business_roles.count.should == 0
  end
end