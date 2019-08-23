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

  def sql_text(date_time = Time.current)
    sql = msql.gsub(/\r\n?/, ' ') # заменим \n \r на пробелы
    if mtype == 'MSSQL'
      sql.gsub!(/##PERIOD##/, period_format_ms(date_time)) # заменим период
      sql.gsub!(/##DATE##/, date_format_ms(date_time)) # заменим дату
    else
      sql.gsub!(/##PERIOD##/, period_format_pg(date_time))
      sql.gsub!(/##DATE##/, date_format_pg(date_time))
    end
    sql
  end

  # возвращает период от первой его секунды до последней - для замены ##PERIOD## в условии between
  def period_format_pg(date_time = Time.current)
    start_s = date_time.strftime('%Y-%m-%d %H').to_s
    return "'#{start_s}:00:00.0' AND '#{start_s}:59:59.999'" unless depth.between?(1, 3)

    case depth
    when 1 then
      begin_of = date_time.beginning_of_year
      end_of = date_time.end_of_year # текущий год
    when 2 then
      begin_of = date_time.beginning_of_month
      end_of = date_time.end_of_month # текущий месяц
    when 3 then
      begin_of = date_time.beginning_of_day
      end_of = date_time.end_of_day # текущий день
    end
    "'#{begin_of.strftime('%Y-%m-%d 00:00:00')}' AND '#{end_of.strftime('%Y-%m-%d 23:59:59')}'"
  end

  def period_format_ms(date_time = Time.current)
    start_s = date_time.strftime('%d.%m.%Y %H').to_s
    return "'#{start_s}:00:00' AND '#{start_s}:59:59'" unless depth.between?(1, 3)

    case depth
    when 1 then
      begin_of = date_time.beginning_of_year
      end_of = date_time.end_of_year # текущий год
    when 2 then
      begin_of = date_time.beginning_of_month
      end_of = date_time.end_of_month # текущий месяц
    when 3 then
      begin_of = date_time.beginning_of_day
      end_of = date_time.end_of_day # текущий день
    end
    "'#{begin_of.strftime('%d.%m.%Y 00:00:00')}' AND '#{end_of.strftime('%d.%m.%Y 23:59:59')}'"
  end

  # возвращает начало периода - для замены ##DATE## в условии where
  def date_format_pg(date_time = Time.current)
    return "'#{date_time.strftime('%Y-%m-%d %H')}'" unless depth.between?(1, 3)

    beginning = case depth
                when 1 then date_time.beginning_of_year # начало года
                when 2 then date_time.beginning_of_month # начало месяц
                when 3 then date_time.beginning_of_day # начало дня
                end
    "'#{beginning.strftime('%Y-%m-%d')}'"
  end

  def date_format_ms(date_time = Time.current)
    return "'#{date_time.strftime('%d.%m.%Y %H')}'" unless depth.between?(1, 3)

    beginning = case depth
                when 1 then date_time.beginning_of_year # начало года
                when 2 then date_time.beginning_of_month # начало месяц
                when 3 then date_time.beginning_of_day # начало дня
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
