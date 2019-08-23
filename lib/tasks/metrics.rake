# frozen_string_literal: true

namespace :bp1step do
  desc 'Set values metrics from local PG SQL'
  task set_values_PG: :environment do # заполнить значения метрик, получаемых из локального pgSQL
    # отбирает метрики с типом 'localPG', исполняет SQL-запрос и заносит результат как текущее значение метрики
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :set_values_PG'

    count = 0
    errors = 0
    Metric.where(mtype: 'localPG').each do |metric| # метрики с типом 'localPG'
      count += 1
      sql = metric.sql_text
      begin
        results = ActiveRecord::Base.connection.execute(sql)
      rescue StandardError => error
        logger.error "     ERR: #{error}\n#{sql}"
        errors += 1
      end
      next unless results

      result = results.first
      next if result['count'].blank?

      new_value = result['count']
      update_or_create_value metric, new_value
    end
    inf = "      localPG: #{count} metrics"
    inf += ", #{errors} errors" if errors.positive?
    logger.info inf
  end

  desc 'Set values metrics from MS SQL'
  task set_values_MSSQL: :environment do # заполнить значения метрик, получаемых из MS SQL
    require 'tiny_tds'
    # отбирает метрики с типом 'MSSQL', исполняет SQL-запрос и заносит результат как текущее значение метрики
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :set_values_MSSQL'

    c = ActiveRecord::Base.configurations['production_MSSQL']
    mssql = TinyTds::Client.new username: c['username'], password: c['password'], host: c['host'], database: c['database']
    mssql.execute('set dateformat DMY;') # установим формат даты

    count = 0
    errors = 0
    # Metric.where(mtype: metrics_type).where(id: 8).each do | metric |  # метрики с типом 'MSSQL'
    Metric.where(mtype: 'MSSQL').each do |metric| # метрики с типом 'MSSQL'
      count += 1
      sql = metric.sql_text
      begin
        results = mssql.execute(sql)
        new_value = 0
        results&.each do |row|
          new_value = row['count']
        end
        update_or_create_value metric, new_value
      rescue StandardError => error
        logger.error "     ERR: #{error}\n#{sql}"
        errors += 1
      end
    end
    mssql.close
    inf = "      MSSQL: #{count} metrics"
    inf += ", #{errors} errors" if errors.positive?
    logger.info inf
  end

  def update_or_create_value(metric, new_value)
    return unless new_value&.positive?

    value = MetricValue.where(metric_id: metric.id).where("dtime BETWEEN #{metric.period_format_pg}").first
    value ||= MetricValue.new(metric_id: metric.id) # не нашли? - новое значение
    value.value = new_value
    value.dtime = Time.current # обновим время записи значения
    value.save
  end
end
