# frozen_string_literal: false

class MetricsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :set_metric, except: %i[new create index] # , only: [:show, :edit, :update, :destroy, :values, :new_value]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @title_metrics = 'Метрики процессов'
    @title_metrics += Metric.by_depth_title(params[:depth]) if params['depth'].present?
    @title_metrics += Metric.by_metric_type_title(params[:mtype]) if params['mtype'].present?
    @metrics = Metric
               .by_depth(params[:depth])
               .by_metric_type(params[:mtype])
               .search(params[:search])
               .paginate(per_page: 10, page: params[:page])
               .order(sort_order(sort_column, sort_direction))
  end

  def show
    @current_period_date = Time.current
    @current_period_date = Time.zone.parse(params[:date]) if params[:date].presence
    @current_period_date = Time.current if @current_period_date > Time.current
    @current_depth = (params[:depth].presence || @metric.depth - 1).to_i
    case @current_depth
    when 1 # год
      @format_period = '%Y'
      @date1 = @current_period_date.beginning_of_year
      @date2 = @current_period_date.end_of_year
      @prev_date = @date1.ago(1.year)
      @next_date = @date2.since(1.year)
      # values = MetricValue.group_by_month(:dtime, range: @date1..@date2, format: "%M").order('MAX(dtime) ASC').count
      values = MetricValue.where(metric_id: @metric.id).order('MAX(dtime) ASC')
                          .group_by_month(:dtime, range: @date1..@date2, time_zone: 'UTC')
                          .sum(:value)
    when 2 # месяц
      @format_period = '%B %Y'
      @date1 = @current_period_date.beginning_of_month
      @date2 = @current_period_date.end_of_month
      @prev_date = @date1.ago(1.month)
      @next_date = @date2.since(1.month)
      values = MetricValue.where(metric_id: @metric.id)
                          .group_by_day(:dtime, range: @date1..@date2, format: '%-d')
                          .order('MAX(dtime) ASC')
                          .sum(:value)
    when 3 # день
      @format_period = '%d.%m.%Y'
      @date1 = @current_period_date.beginning_of_day
      @date2 = @current_period_date.end_of_day
      @prev_date = @date1.ago(1.day)
      @next_date = @date2.since(1.day)
      values = MetricValue.group_by_hour(:dtime, range: @date1..@date2, format: '%H')
                          .order('MAX(dtime) ASC')
                          .sum(:value)
    end
    @current_period_name = @current_period_date.strftime(@format_period)
    @prev_name = @prev_date.strftime(@format_period)
    @next_name = @next_date.strftime(@format_period) if @next_date

    @prev_period_date = @current_period_date - @current_period_date.day
    @next_period_date = @current_period_date.end_of_month + 1
    @next_period_date = nil if @next_period_date == (Time.current.end_of_month + 1)

    @data = [{ name: @current_period_name, data: values, format: '%l %P' }]
    @metrics = Metric.where(bproce_id: @metric.bproce).order(:name)
    respond_with @data
  end

  def new
    @metric = Metric.new
  end

  def edit; end

  def create
    @metric = Metric.new(metric_params)
    @metric.mhash = Digest::MD5.hexdigest(rand.to_s) # для новой метрики создадим HASH по умолчанию
    if @metric.save
      redirect_to @metric, notice: 'Metric was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @metric.update(metric_params)
      redirect_to @metric, notice: 'Metric was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @metric.destroy
    redirect_to metrics_url, notice: 'Metric was successfully destroyed.'
  end

  def values
    @current_period_date = Time.current
    @current_period_date = Time.zone.parse(params[:date]) if params[:date].presence
    @prev_period_date = @current_period_date - @current_period_date.day.days
    @next_period_date = @current_period_date.end_of_month + 1
    @next_period_date = nil if @next_period_date == (Time.current.end_of_month + 1)
    values = MetricValue.where(metric_id: @metric.id)
    @values = case @metric.depth # список значений за выбранный период
              when 1..2
                values.where(dtime: (@current_period_date.beginning_of_year..@current_period_date.end_of_year)).order(:dtime)
              else
                values.where(dtime: (@current_period_date.beginning_of_month..@current_period_date.end_of_month)).order(:dtime)
              end
    @datetime_format = case @metric.depth # формат отображения даты значений выбранного периода
                       when 1 then '%Y'
                       when 2 then '%b %Y'
                       else '%d %m %Y'
                       end
    @metrics = Metric.where(bproce_id: @metric.bproce).order(:name)
  end

  def new_value
    @metric_value = MetricValue.new(metric_id: @metric.id) # заготовка для нового значения
    @metric_value.dtime = params[:dtime] if params[:dtime].present?
    render 'metric_values/new'
  end

  # http: GET /metrics/ID/set?v=VALUE&h=HASH
  # from vpbx-ng http://localhost:3000/metrics/24/set?h=350b87584a23f7fbee07c441b2947d84&v=18
  def set
    if @metric && params[:v].presence && params[:h].presence
      if Digest::MD5.hexdigest(@metric.mhash) == params[:h] && params[:v].to_i.positive?
        update_or_create_value @metric, params[:v].to_i
        head :ok
      else
        head :bad_request
      end
    else
      head :not_found
    end
  end

  def test
    if @metric.mtype == 'MSSQL'
      require 'tiny_tds'
      c = ActiveRecord::Base.configurations['production_MSSQL']
      mssql = TinyTds::Client.new username: c['username'], password: c['password'], host: c['host'], database: c['database']
      mssql.execute('set dateformat DMY')
    end
    @sql = @metric.sql_text Time.current
    @test = 'запрос не указан!'
    return unless @sql

    begin
      @test = ''
      if @metric.mtype == 'MSSQL'
        results = mssql.execute(@sql)
      elsif @metric.mtype == 'localPG'
        results = ActiveRecord::Base.connection.execute(@sql)
      end
      results.each do |row|
        @test << row.inspect
        @test_value = row['count']
      end
    rescue StandardError => e
      logger.info "      ERR: #{@sql}"
      @test << "ERR: #{@sql}\n"
      @test << e.inspect
    ensure
      mssql&.close
    end
  end

  def save_value
    value = params[:value].to_i || 0
    if value.positive?
      update_or_create_value @metric, value
      redirect_to @metric, notice: 'Value of metric was successfully updated.'
    else
      redirect_to @metric, notice: 'New Value must be positive.'
    end
  end

  def set_values
    period_date = Time.zone
    period_date = Tome.zone.parse(params[:date]) if params[:date].presence
    period_date = Time.zone if period_date > Time.zone
    depth = (params[:depth].presence || @metric.depth - 1).to_i

    if @metric.mtype == 'MSSQL'
      require 'tiny_tds'
      c = ActiveRecord::Base.configurations['production_MSSQL']
      mssql = TinyTds::Client.new username: c['username'], password: c['password'], host: c['host'], database: c['database']
    end
    if @metric.msql
      if @metric.mtype == 'MSSQL'
        require 'tiny_tds'
        c = ActiveRecord::Base.configurations['production_MSSQL']
        mssql = TinyTds::Client.new username: c['username'], password: c['password'], host: c['host'], database: c['database']
      end
      case depth
      when 1 then
        d1 = period_date.beginning_of_year
        d2 = period_date.end_of_year
      when 2 then
        d1 = period_date.beginning_of_month
        d2 = period_date.end_of_month
      else
        d1 = period_date.beginning_of_day
        d2 = period_date.end_of_day
      end
      (d1.to_i..d2.to_i).step(1.day) do |d|
        sql = @metric.sql_text Time.at.utc(d)
        new_value = 0
        begin
          if @metric.mtype == 'MSSQL'
            results = mssql.execute(sql)
          elsif @metric.mtype == 'localPG'
            results = ActiveRecord::Base.connection.execute(sql)
          end
          results.each do |row|
            new_value = row['count']
          end
        rescue StandardError => e
          logger.e "      ERR: #{sql}\n#{e}"
        end
        if new_value&.positive?
          update_or_create_value @metric, new_value, Time.at.utc(d)
          logger.e "#{@metric.id} #{value.es}" unless value.save
        end
      end
      mssql&.close
    end
    redirect_to(action: :show) && return
  end

  private

  def set_metric
    @metric = Metric.find(params[:id])
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
  end

  def metric_params
    params.require(:metric).permit(:bproce_id, :name, :shortname, :description, :note,
                                   :depth, :depth_name, :bproce_name, :mtype, :msql, :sort, :direction)
  end

  def sort_column
    params[:sort] || 'id'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def record_not_found
    flash[:alert] = "Метрика ##{params[:id]} не найдена."
    redirect_to action: :index
  end

  def update_or_create_value(metric, new_value, time_at = Time.current)
    return unless new_value&.positive?

    period = "dtime BETWEEN #{metric.period_format_pg}".sanitize
    value = MetricValue.where(metric_id: metric.id).where(period).first
    value ||= MetricValue.new(metric_id: metric.id) # не нашли? - новое значение
    value.value = new_value
    value.dtime = time_at
    value.save
  end
end
