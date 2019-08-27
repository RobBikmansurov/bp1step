# frozen_string_literal: true

FactoryBot.define do
  factory :requirement do
    sequence(:id, &:to_s)
    label         { "requirement#{id}" }
    date { Date.current }
    duedate { Date.current }
    source { 'MyString' }
    sequence(:body) { |n| "body requirement #{n}" }
    status { 0 }
    result { 'MyText' }
  end
end
