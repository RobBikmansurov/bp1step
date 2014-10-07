require 'spec_helper'

describe Role do
  before (:all)do
    Role.all.each { |r| r.destroy }
  end
  before(:each) do
    @role = FactoryGirl.create(:role)
  end

  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_length_of(:name).is_at_least(4) }
    it { should validate_presence_of(:description) }
  end

  context "associations" do
    it { should have_many(:user_roles) }   # бизнес-роли пользователя
    it { should have_many(:users).through(:user_roles) }
  end

  context "validates" do
    it "is valid with valid attributes: name, description" do
      #expect(@role).to be_valid
    end

    it "is not valid without a name" do
      @role.name = nil
      expect(@role).not_to be_valid
    end
    it "it require uniqueness name" do
      @role1 = create(:role)
      expect(@role1).to be_valid
      @role1.name = @role.name
      expect(@role1).not_to be_valid
      @role2 = create(:role)
      expect(@role2).to be_valid
    end
    it "is not valid if length of name < 4" do #validates :name, :presence => true, :length => {:minimum => 4}
      @role.name = "123"
      expect(@role).not_to be_valid
      @role.name = "1234"
      expect(@role).to be_valid
    end

    it "is not valid without a description" do #validates :description, :presence => true
      @role.description = nil
      expect(@role).not_to be_valid
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
