require 'spec_helper'

PublicActivity.enabled = false

describe User do
  before do
    @role = FactoryGirl.create(:role) # создать роль по умолчанию
    @role.name = 'user'
    @role.save
  end
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  context 'mass assignment' do
    it { should allow_mass_assignment_of(:username) }
    it { should allow_mass_assignment_of(:email) }
  end

  context "validates" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  context "associations" do
    it { should have_many(:user_business_role) }   # бизнес-роли пользователя
    it { should have_many(:business_roles).through(:user_business_role) }
    it { should have_many(:user_workplace) }        # рабочие места пользователя
    it { should have_many(:workplaces).through(:user_workplace).dependent(:destroy) }
    it { should have_many(:user_roles).dependent(:destroy) }  # роли доступа пользователя
    it { should have_many(:roles).through(:user_roles) }
    it { should have_many(:bproce) }
    #it { should have_many(:documents).through(:owner_id) }
    it { should have_many(:iresource) }
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

  it 'should have default role' do
    user = FactoryGirl.create(:user)
    user.reload
    user.roles.count.should > 0
  end


end