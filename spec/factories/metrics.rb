# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :metrics do
    sequence(:name) { |n| "metric#{n}" }
    description { "metric#{id}_desscription" }
    depth
    bproce
  end
end
