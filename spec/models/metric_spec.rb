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

    describe 'MSSQL dates format' do
      it 'return dates period for year' do
        metric.depth = 1
        expect(metric.period_format_ms(Date.parse('2019-01-15'))).to eq("'01.01.2019 00:00:00' AND '31.12.2019 23:59:59'")
      end
      it 'return dates period for month' do
        metric.depth = 2
        expect(metric.period_format_ms(Date.parse('2019-02-15'))).to eq("'01.02.2019 00:00:00' AND '28.02.2019 23:59:59'")
      end
      it 'return dates period for day' do
        metric.depth = 3
        expect(metric.period_format_ms(Date.parse('2019-03-15 15:15:00'))).to eq("'15.03.2019 00:00:00' AND '15.03.2019 23:59:59'")
      end
      it 'return dates period for hour' do
        metric.depth = 4
        expect(metric.period_format_ms(Time.zone.parse('2019-03-15 15:15:00')))
          .to eq("'15.03.2019 15:00:00' AND '15.03.2019 15:59:59'")
      end
      it 'return begining of year' do
        metric.depth = 1
        expect(metric.date_format_ms(Date.parse('2019-01-15'))).to eq("'01.01.2019'")
      end
      it 'return begining of month' do
        metric.depth = 2
        expect(metric.date_format_ms(Date.parse('2019-02-15'))).to eq("'01.02.2019'")
      end
      it 'return begining of day' do
        metric.depth = 3
        expect(metric.date_format_ms(Date.parse('2019-03-15 15:15:00'))).to eq("'15.03.2019'")
      end
      it 'return begining of hour' do
        metric.depth = 4
        expect(metric.date_format_ms(Time.zone.parse('2019-03-15 15:15:00'))).to eq("'15.03.2019 15'")
      end
    end

    it 'search' do
      expect(described_class.search('').first).to eq(described_class.first)
    end

    it 'by_depth' do
      expect(described_class.by_depth('').first).to eq(described_class.first)
    end
    it 'by_depth_title empty' do
      expect(described_class.by_depth_title('')).to eq('')
    end
    it 'by_depth_title 2' do
      expect(described_class.by_depth_title(2)).to eq(' [глубина данных: 2]')
    end

    it 'by_metric_type' do
      expect(described_class.by_metric_type('').first).to eq(described_class.first)
    end
    it 'by_metric_type empty' do
      expect(described_class.by_metric_type_title('')).to eq('')
    end
    it 'by_metric_type 3' do
      expect(described_class.by_metric_type_title(3)).to eq(' [тип: 3]')
    end
  end
end
