require 'spec_helper'
#TODO: не проверяется уникальность :username и :email! (не решена техническая проблема с возникающей ошибкой)

describe User do
  context 'mass assignment' do
    it { should allow_mass_assignment_of(:username) }
    it { should allow_mass_assignment_of(:email) }
  end

  context "validates" do
    it { should validate_presence_of(:username) }
    #it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    #it { should validate_uniqueness_of(:email) }
  end

  context "associations" do
    it { should have_many(:user_business_role) }   # бизнес-роли пользователя
    it { should have_many(:business_roles).through(:user_business_role) }
    it { should have_many(:user_workplace) }        # рабочие места пользователя
    it { should have_many(:workplaces).through(:user_workplace) }
    it { should have_many(:user_roles).dependent(:destroy) }  # роли доступа пользователя
    it { should have_many(:roles).through(:user_roles) }
    it { should have_many(:bproce) }
    it { should have_many(:iresource) }
    it { should have_many(:document).through(:user_document) }
    it { should have_many(:user_document).dependent(:destroy) }
  end

end