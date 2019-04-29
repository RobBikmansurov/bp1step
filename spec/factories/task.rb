# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:id, &:to_s)
    name { "task-#{id}" }
    description { "description-task-#{id}" }
    duedate { Date.current + 1 }
    completion_date { Date.current + 1 }
    status 0
  end
end
