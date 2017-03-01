# frozen_string_literal: true
FactoryGirl.define do
  factory :term do
    sequence(:id, &:to_s)
    name { "name#{id}" }
    shortname { "shortname#{id}" }
    description 'test_description'
  end
end
