# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    sequence(:id, &:to_s)
    order_type ""
    codpred 1
    author 1
    contract_number "Д123"
    contract_date { Date.current - 10 }
    due_date { Date.current + 1 }
    status "Новое"
  end
end
