# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractScan, type: :model do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(255) }
    it { is_expected.to validate_presence_of(:contract_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:contract).class_name('Contract') }
  end

  context 'with attached file' do
    it { is_expected.to have_attached_file(:scan) }
    it { is_expected.to validate_attachment_presence(:scan) }

    it do
      expect(subject).not_to validate_attachment_size(:scan)
        .less_than(1.megabytes)
    end
  end
end
