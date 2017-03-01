# frozen_string_literal: true
class Metric < ActiveRecord::Base
  validates :name, presence: true,
                   length: { minimum: 5, maximum: 50 }
  validates :description, presence: true,
                          length: { minimum: 8, maximum: 255 }
  validates :bproce_id, presence: true
  validates :mtype, length: { maximum: 10 }
  validates :mhash, length: { maximum: 32 }

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  attr_accessible :bproce_id, :name, :shortname, :description, :note, :depth, :depth_name, :bproce_name, :mtype, :msql, :mhash

  belongs_to :bproce # метика относится к процессу

  self.per_page = 10

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by(name: name.to_s).id if name.present?
  end

  def depth_name
    METRICS_VALUE_DEPTH.key(depth)
  end

  def depth_name=(key)
    self.depth = METRICS_VALUE_DEPTH[key]
  end

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

  # возвращает период от первой его секунды до последней - для замены ##PERIOD## в условии between
  # rubocop:disable Metrics/AbcSize
  def sql_period(date = Date.current, dpth = depth)
    case dpth
    when 1 then "'#{date.beginning_of_year.to_s(:db)}' AND '#{date.end_of_year.to_s(:db)}'" # текущий год
    when 2 then "'#{date.beginning_of_month.to_s(:db)}' AND '#{date.end_of_month.to_s(:db)}'" # текущий месяц
    when 3 then "'#{date.beginning_of_day.to_s(:db)}' AND '#{date.end_of_day.to_s(:db)}'" # текущий день
    else "'#{date.strftime('%Y-%m-%d %H:00:00.0')}' AND '#{date.strftime('%Y-%m-%d %H:59:59.999')}'" # текущий час
    end
  end

  # возвращает начало периода - для замены ##DATE## в условии where
  def sql_period_beginning_of(date = Date.current, dpth = depth)
    case dpth
    when 1 then "'#{date.beginning_of_year.strftime('%Y-%m-%d')}'" # начало года
    when 2 then "'#{date.beginning_of_month.strftime('%Y-%m-%d')}'" # начало месяц
    when 3 then "'#{date.beginning_of_day.strftime('%Y-%m-%d')}'" # начало дня
    else "'#{date.strftime('%Y-%m-%d %H')}'" # начало часа
    end
  end
end
