# frozen_string_literal: true

FactoryBot.define do
  factory :user_letter do
    user
    letter
    status 1
  end
end
