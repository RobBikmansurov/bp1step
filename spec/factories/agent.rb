# frozen_string_literal: true

FactoryBot.define do
  factory :agent do
    sequence(:id, &:to_s)
    name { "agent-#{id}" }
    town { "city#{id}" }
  end
end
