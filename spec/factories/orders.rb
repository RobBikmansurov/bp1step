# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    sequence(:id, &:to_s)
    order_type "Распоряжение об открытии счетов"
    codpred 1
    author 1
    contract_number "КОНТРАКТ++123"
    contract_date { Date.current - 10 }
    due_date { Date.current + 1 }
    status "Новое"
  end
end
