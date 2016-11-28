# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :document do
    name 'document_name'
    dlevel '1'
    place 'office1'
    #owner_id user
    trait :invalid do
      name ''
    end
  end
end
