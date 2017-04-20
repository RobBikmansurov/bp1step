# frozen_string_literal: true

FactoryGirl.define do
  factory :document_directive do
    sequence(:id, &:to_s)
    note          { "note#{id}" }
    trait :invalid do
      note ''
    end
  end
end
