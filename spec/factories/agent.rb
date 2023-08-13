# frozen_string_literal: true

FactoryBot.define do
  factory :agent do
    name { Faker::Company.name }
    town { Faker::Address.city }
  end
end
