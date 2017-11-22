# frozen_string_literal: true

# Read about factories at http://github.com/thoughtbot/factory_bot
FactoryBot.define do
  factory :metric_values do
    sequence(:value, &:to_s)
    metric
  end
end
