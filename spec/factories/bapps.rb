# frozen_string_literal: true

FactoryBot.define do
  factory :bapp do
    sequence(:name) { |n| "name#{n}" }
    description { "name#{id}_desscription" }
  end
end
