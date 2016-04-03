require 'spec_helper'

describe Role do

  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(4) }
    it { should validate_presence_of(:description) }
  end

  context "associations" do
    it { should have_many(:user_roles) }   # бизнес-роли пользователя
    it { should have_many(:users).through(:user_roles) }
  end

end
