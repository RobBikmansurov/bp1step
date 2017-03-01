# frozen_string_literal: true
FactoryGirl.define do
  factory :bproce do
    sequence(:id, &:to_s)
    name { "bproce_name_#{id}" }
    shortname { "bp.#{id}" }
    fullname 'test process full name'
  end
end
