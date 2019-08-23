# frozen_string_literal: true

FactoryBot.define do
  factory :letter do
    sequence(:id, &:to_s)
    number { "LET--#{id}" }
    regnumber { 'MyString' }
    regdate { Date.current }
    date { Date.current }
    duedate { Date.current + 1 }
    subject { 'MyString' }

    source { 'MyString' }
    sender { 'MyText' }
    body { 'MyText' }
    status { 1 }
    result { 'MyText' }
  end
end
