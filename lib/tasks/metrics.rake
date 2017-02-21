# encoding: utf-8
# frozen_string_literal: true
namespace :bp1step do
  desc 'Set values metrics from local PG SQL'
  task set_values_PG: :environment do # заполнить значения метрик, получаемых из локального pgSQL
    # отбирает метрики с типом 'localPG', исполняет SQL-запрос и заносит результат как текущее значение метрики
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :set_values_PG'

    count = 0
    Metric.where(mtype: 'localPG').each do |metric| # метрики с типом 'localPG'
      count += 1
      # sql = Metric.find(metric.id).msql
      sql = metric.msql
      sql.gsub!(/\r\n?/, ' ') # заменим \n \r на пробелы
      sql_period = metric.sql_period Time.current.utc
      sql.gsub!(/##PERIOD##/, sql_period) # заменим период
      sql_date = metric.sql_period_beginning_of Time.current.utc
      sql.gsub!(/##DATE##/, sql_date) # заменим дату
      begin
        results = ActiveRecord::Base.connection.execute(sql)
      rescue
        logger.info "      ERR: #{sql}"
      end
      next unless results
      result = results.first
      next unless result['count'].present?
      new_value = result['count'].to_i
      value = MetricValue.where(metric_id: metric.id).where("dtime BETWEEN #{sql_period}").first
      value = MetricValue.new(metric_id: metric.id) unless value # не нашли?
      value.dtime = Time.current.utc # обновим время записи значения
      value.value = new_value
      value.save if new_value.positive?
    end
    logger.info "      localPG: #{count} metrics"
  end

  desc 'Set values metrics from MS SQL'
  task set_values_MSSQL: :environment do # заполнить значения метрик, получаемых из MS SQL
    require 'tiny_tds'
    # отбирает метрики с типом 'MSSQL', исполняет SQL-запрос и заносит результат как текущее значение метрики
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :set_values_MSSQL'

    c = ActiveRecord::Base.configurations['production_MSSQL']
    mssql = TinyTds::Client.new username: c['username'], password: c['password'], host: c['host'], database: c['database']

    count = 0
    errors = 0
    # Metric.where(mtype: metrics_type).where(id: 8).each do | metric |  # метрики с типом 'MSSQL'
    Metric.where(mtype: 'MSSQL').each do |metric| # метрики с типом 'MSSQL'
      count += 1
      # ('2016-02-01'.to_datetime.to_i .. '2016-02-09'.to_datetime.to_i).step(1.day) do |datei|
      date = Time.current.utc
      sql = Metric.find(metric.id).msql
      sql.gsub!(/\r\n?/, ' ') # заменим \n \r на пробелы

      sql_period = metric.sql_period date
      sql.gsub!(/##PERIOD##/, sql_period) # заменим период

      sql_date = metric.sql_period_beginning_of date
      sql.gsub!(/##DATE##/, sql_date) # заменим дату
      begin
        results = mssql.execute(sql)
        new_value = nil
        results.each do |row|
          new_value = row['count']
        end
        if new_value
          if new_value.positive?
            value = MetricValue.where(metric_id: metric.id).where("dtime BETWEEN #{sql_period}").first
            value = MetricValue.new(metric_id: metric.id) unless value # не нашли? - новое значение
            value.value = new_value
            value.dtime = Time.current.utc # обновим время записи значения
            value.save
          end
        end
      rescue => e
        logger.info "      ERR: #{sql}\n#{e}"
        # puts "ERR: #{sql}\n#{e}"
        errors += 1
      end
    end
    mssql.close
    inf = "      MSSQL: #{count} metrics"
    inf += ", #{errors} errors" if errors.positive?
    logger.info inf
  end
end
