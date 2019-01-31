# frozen_string_literal: true

# Read about factories at http://github.com/thoughtbot/factory_bot
FactoryBot.define do
  factory :metric_value do
    sequence(:value, &:to_s)
    dtime { Time.current }
    metric
  end
end
