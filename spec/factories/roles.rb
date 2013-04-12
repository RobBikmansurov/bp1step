FactoryGirl.define do
  factory :role do
    sequence(:id) { |n| "#{n}" }
    name      { "name#{id}" }
    description 'test_role_description'
  end

end