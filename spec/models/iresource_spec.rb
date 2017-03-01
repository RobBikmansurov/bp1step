# frozen_string_literal: true
require 'rails_helper'

describe Iresource do
  context 'validates' do
    it { should validate_presence_of(:label) }
    # it { should validate_uniqueness_of(:label) }
    it { should validate_length_of(:label).is_at_least(3).is_at_most(20) }
    it { should validate_presence_of(:location) }
    it { should validate_length_of(:location).is_at_least(3).is_at_most(255) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:bproce_iresources) }
    it { should have_many(:bproces).through(:bproce_iresources) }
  end
end
