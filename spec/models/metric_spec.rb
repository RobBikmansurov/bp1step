# frozen_string_literal: true

require 'rails_helper'

describe Metric do
  let(:user)     { FactoryBot.create :user }
  let(:bproce)   { FactoryBot.create(:bproce, user_id: user.id) }
  let(:metric)   { FactoryBot.create(:metric, bproce_id: bproce.id, depth: 2) }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:name) }
    # it { should validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(5).is_at_most(50) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:mtype).is_at_most(10) }
    it { is_expected.to validate_length_of(:mhash).is_at_most(32) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
  end

  context 'with methods' do
    it 'return process name' do
      expect(metric.bproce_name).to eq(bproce.name)
    end
    it 'set process name by name' do
      bproce1 = FactoryBot.create :bproce, user_id: user.id, name: 'New Process'
      metric.bproce_name = 'New Process'
      expect(metric.bproce_name).to eq(bproce1.name)
    end

    it 'set depth by key`s name' do
      metric.depth_name = 'Год'
      expect(metric.depth_name).to eq('Год')
    end

    it 'return dates period for year' do
      expect(metric.sql_period(Date.parse('2019-01-15'), 1)).to eq("'2019-01-01' AND '2019-12-31'")
    end
    it 'return dates period for month' do
      expect(metric.sql_period(Date.parse('2019-01-15'), 2)).to eq("'2019-01-01' AND '2019-01-31'")
    end
    it 'return dates period for day' do
      expect(metric.sql_period(Date.parse('2019-01-15 15:15:00'), 3)).to eq("'2019-01-14 19:00:00' AND '2019-01-15 18:59:59'")
    end
    it 'return begining of year' do
      expect(metric.sql_period_beginning_of(Date.parse('2019-01-15'), 1)).to eq("'2019-01-01'")
    end
    it 'return begining of month' do
      expect(metric.sql_period_beginning_of(Date.parse('2019-01-15'), 2)).to eq("'2019-01-01'")
    end
    it 'return begining of day' do
      expect(metric.sql_period_beginning_of(Date.parse('2019-01-15 15:15:00'), 3)).to eq("'2019-01-15'")
    end

    it 'search' do
      expect(described_class.search('').first).to eq(described_class.first)
    end
  end
end
