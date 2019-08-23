# frozen_string_literal: true

FactoryBot.define do
  factory :bproce_document do
    bproce
    document
    purpose { 'test' }
  end
end
