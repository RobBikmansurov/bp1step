# frozen_string_literal: true

FactoryBot.define do
  factory :bproce do
    sequence(:id, &:to_s)
    name { "bproce_name_#{id}" }
    shortname { "bp.#{id}" }
    fullname 'test process full name'
    goal 'goal of bproce'
  end
end
