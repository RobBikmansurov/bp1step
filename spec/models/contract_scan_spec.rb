# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ContractScan, type: :model do
  context 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(255) }
    it { should validate_presence_of(:contract_id) }
  end

  context 'associations' do
    it { should belong_to(:contract).class_name('Contract') }
  end

  context 'have_attached_file' do
    it { should have_attached_file(:scan) }
    it { should validate_attachment_presence(:scan) }
    it do
      should_not validate_attachment_size(:scan)
        .less_than(1.megabytes)
    end
  end
end
