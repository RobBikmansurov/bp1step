# frozen_string_literal: true

require 'rails_helper'
# TODO: не проверяется уникальность :username и :email! (не решена техническая проблема с возникающей ошибкой)

describe User do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:username) }
    # it { should validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    # it { should validate_uniqueness_of(:email).with_message("уже существует") }
    # it { should validate_uniqueness_of(:email) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:user_business_role) } # бизнес-роли пользователя
    it { is_expected.to have_many(:business_roles).through(:user_business_role) }
    it { is_expected.to have_many(:user_workplace) } # рабочие места пользователя
    it { is_expected.to have_many(:workplaces).through(:user_workplace) }
    it { is_expected.to have_many(:user_roles).dependent(:destroy) } # роли доступа пользователя
    it { is_expected.to have_many(:roles).through(:user_roles) }
    it { is_expected.to have_many(:bproce) }
    it { is_expected.to have_many(:iresource) }
    it { is_expected.to have_many(:document).through(:user_document) }
    it { is_expected.to have_many(:user_document).dependent(:destroy) }
  end
end
