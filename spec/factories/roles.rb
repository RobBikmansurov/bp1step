FactoryGirl.define do
  factory :role do
    sequence(:id) { |n| "#{n}" }
    name      { "role#{id}" }
    description 'role_description'
  end
end