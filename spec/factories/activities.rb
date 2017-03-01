# frozen_string_literal: true
FactoryGirl.define do
  factory :activity do
    association :user
  end
end
