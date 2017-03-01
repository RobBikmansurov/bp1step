# frozen_string_literal: true
FactoryGirl.define do
  factory :user_role do
    role
    user
    note 'user_role'
  end
end
