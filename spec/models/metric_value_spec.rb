# frozen_string_literal: true

require 'rails_helper'

describe MetricValue do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:dtime) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:metric) }
  end
end
