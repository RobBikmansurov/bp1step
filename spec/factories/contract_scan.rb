# frozen_string_literal: true

FactoryBot.define do
  factory :contract_scan do
    sequence(:id, &:to_s)
    name { "scan#{id}" }
    scan { File.new Rails.root.join('spec', 'support', 'test.odt') }
    contract
  end
end
