# frozen_string_literal: true

class Metric < ApplicationRecord
  include BproceNames

  validates :name, presence: true,
                   length: { minimum: 5, maximum: 50 }
  validates :description, presence: true,
                          length: { minimum: 8, maximum: 255 }
  validates :bproce_id, presence: true
  validates :mtype, length: { maximum: 10 }
  validates :mhash, length: { maximum: 32 }

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :bproce # метика относится к процессу

  self.per_page = 10

  def depth_name
    METRICS_VALUE_DEPTH.key(depth)
  end

  def depth_name=(key)
    self.depth = METRICS_VALUE_DEPTH[key]
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
  end

  # возвращает период от первой его секунды до последней - для замены ##PERIOD## в условии between
  def sql_period(date = Date.current, dpth = depth)
    return "'#{date.strftime('%d.%m.%Y %H:00:00.0')}' AND '#{date.strftime('%d.%m.%Y %H:59:59.999')}'" unless dpth.between?(1, 3)

    case dpth
    when 1 then
      begin_of = date.beginning_of_year
      end_of = date.end_of_year # текущий год
    when 2 then
      begin_of = date.beginning_of_month
      end_of = date.end_of_month # текущий месяц
    when 3 then
      begin_of = date.beginning_of_day
      end_of = date.end_of_day # текущий день
    end
    "'#{begin_of.strftime('%d.%m.%Y 00:00:00.0')}' AND '#{end_of.strftime('%d.%m.%Y 23:59:59.999')}'"
  end

  # возвращает начало периода - для замены ##DATE## в условии where
  def sql_period_beginning_of(date = Date.current, dpth = depth)
    return "'#{date.strftime('%d.%m.%Y %H')}'" unless dpth.between?(1, 3)

    beginning = case dpth
                when 1 then date.beginning_of_year # начало года
                when 2 then date.beginning_of_month # начало месяц
                when 3 then date.beginning_of_day # начало дня
                end
    "'#{beginning.strftime('%d.%m.%Y')}'"
  end

  def self.by_depth(depth)
    return where(nil) if depth.blank?

    where(depth: depth)
  end

  def self.by_depth_title(depth)
    return '' if depth.blank?

    " [глубина данных: #{depth}]"
  end

  def self.by_metric_type(metric_type)
    return where(nil) if metric_type.blank?

    where(mtype: metric_type)
  end

  def self.by_metric_type_title(metric_type)
    return '' if metric_type.blank?

    " [тип: #{metric_type}]"
  end
end
