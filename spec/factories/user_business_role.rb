# frozen_string_literal: true

FactoryBot.define do
  factory :user_business_role do
    note { 'note' }
    business_role
    user
  end
end
