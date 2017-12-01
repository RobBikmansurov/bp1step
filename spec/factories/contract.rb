# frozen_string_literal: true

FactoryBot.define do
  factory :contract do
    sequence(:id, &:to_s)
    number        { "10#{id}" }
    name          { "name#{id}" }
    contract_type 'Contract'
    status        'Действует'
    date_begin    Date.current
    date_end      Date.current + 100
    description   'contract_description'
    trait :invalid do
      name ''
    end
    agent
  end
end
