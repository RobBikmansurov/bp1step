# frozen_string_literal: true

FactoryBot.define do
  factory :user_task do
    user
    task
    status { 1 }
  end
end
