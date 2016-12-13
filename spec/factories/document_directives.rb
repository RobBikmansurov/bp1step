FactoryGirl.define do
  factory :document_directive do
    sequence(:id) { |n| "#{n}" }
    note          { "note#{id}" }
    trait :invalid do
      note ''
    end
  end
end
