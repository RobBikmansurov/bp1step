FactoryGirl.define do
  factory :business_role do
    name 'business_role_name'
    description "business_role_description"
    trait :invalid do
      name ''
    end
  end
end
