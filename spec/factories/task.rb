# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:id, &:to_s)
    name { "task-#{id}" }
    description { "description-task-#{id}" }
    duedate { Date.current + 1 }
    status 0
  end
  # id: 746, name: "Тестовая ", description: "тест", duedate: "2017-12-08", result: "", status: 0, completion_date: nil, letter_id: nil, requirement_id: nil, author_id: 104, created_at: "2017-11-28 07:32:45", updated_at: "2017-11-28 07:32:45"
end
