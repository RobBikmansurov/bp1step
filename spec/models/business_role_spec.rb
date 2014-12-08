require 'spec_helper'

describe BusinessRole do

  it "is has a valid factory" do
    expect(build(:business_role)).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_least(5).is_at_most(50) }
    it { should validate_presence_of(:bproce_id) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:description).is_at_least(8) }
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
