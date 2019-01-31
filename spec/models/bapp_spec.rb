# frozen_string_literal: true

require 'rails_helper'

describe Bapp do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(4).is_at_most(50) }
    it { is_expected.to validate_presence_of(:description) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:bproce_bapps) }
    it { is_expected.to have_many(:bproces).through(:bproce_bapps) }
  end
  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
  it 'have searchtype method' do
    expect(described_class.searchtype('').first).to eq(described_class.first)
  end
end
