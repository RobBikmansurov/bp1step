# frozen_string_literal: true

FactoryBot.define do
  factory :contract_scan do
    sequence(:id, &:to_s)
    name { "scan#{id}" }
    scan_file_name 'filename.ext'
    contract
  end
end
