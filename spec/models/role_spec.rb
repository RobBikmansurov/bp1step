# frozen_string_literal: true

require 'rails_helper'

describe Role do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(4) }
    it { is_expected.to validate_presence_of(:description) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:user_roles) } # бизнес-роли пользователя
    it { is_expected.to have_many(:users).through(:user_roles) }
  end

  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
