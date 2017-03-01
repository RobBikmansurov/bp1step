# frozen_string_literal: true
require 'rails_helper'

describe Workplace do
  context 'validates' do
    it { should validate_presence_of(:designation) }
    # it { should validate_uniqueness_of(:designation) }
    it { should validate_length_of(:designation).is_at_least(5).is_at_most(50) }
  end

  context 'associations' do
    it { should have_many(:bproce_workplaces) }
    it { should have_many(:bproces).through(:bproce_workplaces) }
    it { should have_many(:user_workplace) }
    it { should have_many(:users).through(:user_workplace) }
  end
end
