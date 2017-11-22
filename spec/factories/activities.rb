# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    association :user
  end
end
