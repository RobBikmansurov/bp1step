# frozen_string_literal: true

# Read about factories at http://github.com/thoughtbot/factory_bot
FactoryBot.define do
  factory :document do
    sequence(:name) { |n| "document_name_#{n}" }
    dlevel { 1 }
    place { 'office1' }
    status { 'Действует' }
    trait :invalid do
      name { '' }
    end
  end
end
