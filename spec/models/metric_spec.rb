# frozen_string_literal: true

require 'rails_helper'

describe Metric do
  let(:user)     { FactoryBot.create :user }
  let(:bproce)   { FactoryBot.create(:bproce, user_id: user.id) }
  let!(:bproce1) { FactoryBot.create(:bproce, user_id: user.id, name: 'New Process') }
  let(:metric)   { FactoryBot.create(:metric, bproce_id: bproce.id, depth: 2) }
  context 'validates' do
    it { should validate_presence_of(:name) }
    # it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(5).is_at_most(50) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:mtype).is_at_most(10) }
    it { should validate_length_of(:mhash).is_at_most(32) }
  end

  context 'associations' do
    it { should belong_to(:bproce) }
  end

  context 'methods' do
    it 'return process name' do
      expect(metric.bproce_name).to eq(bproce.name)
    end
    it 'set process name by name' do
      metric.bproce_name = 'New Process'
      expect(metric.bproce_name).to eq(bproce1.name)
    end

    it 'return depth name' do
      expect(metric.depth_name).to eq('Месяц')
    end

    it 'return dates period' do
      expect(metric.sql_period(date = Date.parse('2019-01-15'), dpth = 1)).to eq("'2019-01-01' AND '2019-12-31'")
      expect(metric.sql_period(date = Date.parse('2019-01-15'), dpth = 2)).to eq("'2019-01-01' AND '2019-01-31'")
      expect(metric.sql_period(date = Date.parse('2019-01-15 15:15:00'), dpth = 3)).to eq("'2019-01-14 19:00:00' AND '2019-01-15 18:59:59'")
    end
    it 'return begining of sql period' do
      expect(metric.sql_period_beginning_of(date = Date.parse('2019-01-15'), dpth = 1)).to eq("'2019-01-01'")
      expect(metric.sql_period_beginning_of(date = Date.parse('2019-01-15'), dpth = 2)).to eq("'2019-01-01'")
      expect(metric.sql_period_beginning_of(date = Date.parse('2019-01-15 15:15:00'), dpth = 3)).to eq("'2019-01-15'")
    end
  end
end
