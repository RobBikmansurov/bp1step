# frozen_string_literal: true

FactoryGirl.define do
  factory :bapp do
    sequence(:name) { |n| "name#{n}" }
    description { "name#{id}_desscription" }
  end
end
