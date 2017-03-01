# frozen_string_literal: true
FactoryGirl.define do
  factory :current_user do
    sequence(:username) { |n| "cname#{n}" }
    password 'foobar'
    email { "#{username}@example.com" }
    password_confirmation 'foobar'
  end
end
