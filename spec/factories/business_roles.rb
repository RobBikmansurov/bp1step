# frozen_string_literal: true

FactoryBot.define do
  factory :business_role do
    sequence(:name) { |n| "business_role-#{n}" }
    description { "#{name}_desscription" }
    features 'feat'
    bproce
  end
end
