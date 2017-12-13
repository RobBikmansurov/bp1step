# frozen_string_literal: true

class MetricValue < ActiveRecord::Base
  validates :value, presence: true
  validates :dtime, presence: true

  belongs_to :metric

  # attr_accessible :metric_id, :dtime, :value

  scope :by_time, ->(start, finish) { where(dtime: (start..finish)) }

  class << self
    def by_month_totals(metric_id, date) # по месяцам за год
      by_time(date.beginning_of_year, date.end_of_year)
        .where(metric_id: metric_id)
        .order('MAX(dtime) ASC')
        .group_by_month(:dtime).sum(:value)
    end

    def by_day_totals(metric_id, date) # по дням месяца за месяц
      by_time(date.beginning_of_month, date.end_of_month)
        .where(metric_id: metric_id)
        .order('MAX(dtime) ASC')
        .group_by_day(:dtime).sum(:value)
    end

    def by_year_totals(metric_id, date)
      by_time(date.beginning_of_year, date.end_of_year)
        .where(metric_id: metric_id)
        .order('MAX(dtime) ASC')
        .group_by_week(:dtime).sum(:value)
    end
  end
end
