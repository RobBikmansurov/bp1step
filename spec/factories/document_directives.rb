FactoryGirl.define do
  factory :document_directive do
    sequence(:id) { |n| "#{n}" }
    document
    directive
  end
end