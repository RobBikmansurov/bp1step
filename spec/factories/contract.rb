FactoryGirl.define do
  factory :contract do
    sequence(:id)  { |n| "#{n}" }
    number     	   { "10#{id}" }
    name      	   { "name#{id}" }
    contract_type  'Contract'
    status 'Действует'
    description    'contract_description'
    trait :invalid do
      name ''
    end
  end
end
