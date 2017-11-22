# frozen_string_literal: true

FactoryBot.define do
  factory :requirement do
    sequence(:id, &:to_s)
    label         { "requirement#{id}" }
    date Date.current
    duedate Date.current
    source 'MyString'
    body 'MyText'
    status 'MyString'
    result 'MyText'
  end
end
