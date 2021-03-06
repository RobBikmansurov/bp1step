# frozen_string_literal: true

# Read about factories at http://github.com/thoughtbot/factory_bot
FactoryBot.define do
  factory :metric do
    sequence(:name) { |n| "metric#{n}" }
    description { "#{name}_desscription" }
    depth { 1 }
    bproce
  end
end
