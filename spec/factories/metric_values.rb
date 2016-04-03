# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :metric_values do
    sequence(:value) { |n| "#{n}" }
    metric
  end
end
