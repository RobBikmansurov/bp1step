# frozen_string_literal: true

FactoryGirl.define do
  factory :workplace do
    sequence(:name) { |n| "workplace#{n}" }
    description 'WP description'
    sequence(:designation) { |n| "WP--#{n}" }
    location          'of.100'
    switch            'sw 1'
    port              1
  end
end
