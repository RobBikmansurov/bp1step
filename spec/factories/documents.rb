# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :document do
    sequence(:name) { |n| "name#{n}" }
    dlevel '1'
    place 'office1'
    owner user
  end
end
