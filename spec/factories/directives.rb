# frozen_string_literal: true

# Read about factories at http://github.com/thoughtbot/factory_bot
FactoryBot.define do
  factory :directive do
    sequence(:name) { |n| "directive_name#{n}" }
    number 'number'
    approval { Time.current }
    body 'Орган'
    status 'Проект'
  end
end
