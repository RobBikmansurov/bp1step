require 'spec_helper'

PublicActivity.enabled = false

describe Workplace do
before(:each) do
    @wp = create(:workplace)
  end

  context "validates" do
    it "is valid with valid attributes: name, description, designation" do
      @wp.should be_valid
    end

    it "is not valid without a designation" do #validates :designation, :presence => true, :uniqueness => true, :length => {:minimum => 8, :maximum => 50}
      @wp.designation = nil
      @wp.should_not be_valid
    end
    it "it require uniqueness designation" do
      @wp1 = create(:workplace, designation: "WorkplaceDesignation1")
      @wp1.should be_valid
      @wp1.designation = 'WorkplaceDesignation'
      @wp1.should_not be_valid
      @wp2 = create(:workplace, designation: "WorkplaceDesignation2")
      @wp2.should be_valid
    end
    it "is not valid if length of designation < 8 or > 50" do
      @wp.designation = "1234567"
      @wp.should_not be_valid
      @wp.designation = "12345678"
      @wp.should be_valid
      @wp.designation = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
      @wp.should_not be_valid
      @wp.designation = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5"
      @wp.should be_valid
    end
  end

  context "associations" do
    it "has_many :bproce_workplaces" do
      should have_many(:bproce_workplaces) #рабочее место относится ко многим процессам
    end
    it "has_many :bproces, :through => :bproce_workplaces" do
      should have_many(:bproces).through(:bproce_workplaces)
    end
    it "has_many :user_workplace" do
      should have_many(:user_workplace) # на рабочем месте может быть много исполнителей
    end
    it "has_many :user_workplace, :through => :user_workplace" do
      should have_many(:users).through(:user_workplace)
    end
  end

end
