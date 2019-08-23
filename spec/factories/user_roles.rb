# frozen_string_literal: true

FactoryBot.define do
  factory :user_role do
    role
    user
    note { 'user_role' }
  end
end
