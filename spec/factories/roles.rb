# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    sequence(:id, &:to_s)
    name { "role#{id}" }
    description 'role_description'
  end
end
