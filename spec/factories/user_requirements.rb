# frozen_string_literal: true

FactoryBot.define do
  factory :user_requirement do
    user
    requirement
    status 1
  end
end
