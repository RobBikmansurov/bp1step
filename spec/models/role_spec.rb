require 'spec_helper'

describe Role do
  before(:each) do
    #@role = factory :role
    #let(:role) { FactoryGirl.create :role }
    @role = Role.new
    @role.name = 'test_role_name'
    @role.description = 'test_role_description'
    @role.save
  end

  context "validates" do
    it "is valid with valid attributes: name, description" do
      @role.should be_valid
    end

    it "is not valid without a name" do
      @role.name = nil
      @role.should_not be_valid
    end
    it "it require uniqueness name" do
      @role1 = Role.new
      @role1.name = "test_role_name"
      @role1.description='test_description'
      @role1.should_not be_valid
      @role1.save
      @role2 = Role.new
      @role2.name = "test_role_name2"
      @role2.description='test_description'
      @role2.should be_valid
      @role2.save
    end
    it "is not valid if length of name < 5" do #validates :name, :presence => true, :length => {:minimum => 5}
      @role.name = "1234"
      @role.should_not be_valid
      @role.name = "12345"
      @role.should be_valid
    end

    it "is not valid without a description" do #validates :description, :presence => true
      @role.description = nil
      @role.should_not be_valid
    end
  end

  context "associations" do
    it "has_many :user_roles" do
      should have_many(:user_roles) # у пользователя может быть много ролей доступа
    end
    it "has_many :user, :through => :user_roles" do
      should have_many(:users).through(:user_roles) # роль доступа может быть у многих пользователей
    end
  end

end
