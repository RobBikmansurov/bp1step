# frozen_string_literal: true

require 'rails_helper'

describe Iresource do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_uniqueness_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_least(3).is_at_most(20) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_length_of(:location).is_at_least(3).is_at_most(255) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:bproce_iresources) }
    it { is_expected.to have_many(:bproces).through(:bproce_iresources) }
  end
end
