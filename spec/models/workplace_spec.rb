# frozen_string_literal: true

require 'rails_helper'

describe Workplace do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:designation) }
    it { is_expected.to validate_uniqueness_of(:designation) }
    it { is_expected.to validate_length_of(:designation).is_at_least(5).is_at_most(50) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:bproce_workplaces) }
    it { is_expected.to have_many(:bproces).through(:bproce_workplaces) }
    it { is_expected.to have_many(:user_workplace) }
    it { is_expected.to have_many(:users).through(:user_workplace) }
  end
end
