require 'spec_helper'

describe BusinessRole do
  before(:each) do
    @business_role = create(:business_role)
  end

  context "validates" do
    it "is valid with valid attributes: name, description, bproce_id" do
      @business_role.should be_valid
    end
    it "is not valid without a name" do #validates :name, :presence => true, :length => {:minimum => 5, :maximum => 50}
      @business_role.name = nil
      @business_role.should_not be_valid
    end
    it "is not valid if length of name < 5 or > 50" do
      @business_role.name = "1234"
      @business_role.should_not be_valid
      @business_role.name = '1234567890'
      @business_role.should be_valid
      @business_role.name = "1234567890" * 5 + "1"
      @business_role.should_not be_valid
      @business_role.name = "1234567890" * 5 
      @business_role.should be_valid
    end
    it "is not valid without a description" do #validates :description, :presence => true, :length => {:minimum => 8}
      @business_role.description = nil
      @business_role.should_not be_valid
    end
    it "is not valid if length of description < 8" do
      @business_role.description = "1234567"
      @business_role.should_not be_valid
      @business_role.description = '12345678'
      @business_role.should be_valid
    end

    it "is not valid without a bproce_id" do #validates :bproce_id, :presence => true
      @business_role.bproce_id = nil
      @business_role.should_not be_valid
    end
  end

  context "associations" do
    it "belongs_to :bproce" do
      should belong_to(:bproce) # бизнес-роль в процессе
    end
    it "has_many :user_business_role" do
      should have_many(:user_business_role) # бизнес-роль может исполняться многими пользователями
    end
    it "has_many :users, :through => :user_business_role" do #has_many :users, :through => :user_business_role
      should have_many(:users).through(:user_business_role) #приложение относится ко многим процессам
    end
  end

end
