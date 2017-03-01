# frozen_string_literal: true
require 'rails_helper'

describe Contract do
  context 'validates' do
    it { should validate_presence_of(:number) }
    it { should validate_length_of(:number).is_at_least(1).is_at_most(20) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(255) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_least(8).is_at_most(255) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:status).is_at_least(5).is_at_most(15) }
    it { should validate_length_of(:contract_type).is_at_least(5).is_at_most(30) }
    it { should validate_length_of(:contract_place).is_at_most(30) }
  end

  context 'associations' do
    it { should belong_to(:parent).class_name('Contract') }
    it { should belong_to(:owner).class_name('User') }
    it { should belong_to(:payer).class_name('User') }
    it { should belong_to(:agent).class_name('Agent') }
    it { should have_many(:bproce_contract).dependent(:destroy) }
    it { should have_many(:contract_scan).dependent(:destroy) }
  end
end
