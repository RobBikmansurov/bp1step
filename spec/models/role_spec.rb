require 'spec_helper'

describe Role do
  before(:each) do
    @role = Role.new
    @role.name = 'test_role_name'
    @role.description = 'test_role_description'
  end

  it "should be valid" do
    @role.should be_valid
  end

  it "should require name" do	#validates :name, :presence => true, :length => {:minimum => 5}
    @role.name = "1234"
    @role.should_not be_valid
    @role.name = "12345"
    @role.should be_valid
  end

  it "should require description" do	#validates :description, :presence => true
    @role.description = ""
    @role.should_not be_valid
  end

  #it "should can have many users" do	#has_many :user_roles
  										# has_many :user, :through => :user_roles
  #  @user = User.create(:username => "test_name", :email => "test@example.com", :password => "password")
  #  @user.roles = [1,2]
  #  @user.roles.count.should = 2
  #end


end
