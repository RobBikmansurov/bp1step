# frozen_string_literal: true
FactoryGirl.define do
  factory :agent do
    sequence(:id, &:to_s)
    name { "agent-#{id}" }
  end
end
