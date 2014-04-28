require 'spec_helper'

PublicActivity.enabled = false

describe Workplace do
before(:each) do
    @wp = create(:workplace)
  end

  context "validates" do
    it { should validate_presence_of(:designation) }
    it { should validate_uniqueness_of(:designation) }
    it { should ensure_length_of(:designation).is_at_least(5).is_at_most(50) }
    #it { should validate_presence_of(:description) }
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
