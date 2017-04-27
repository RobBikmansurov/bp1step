class MetricsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :set_metric, except: %i[new create index] # , only: [:show, :edit, :update, :destroy, :values, :new_value]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @title_metrics = 'Метрики процессов'
    if params[:depth].present?
      @metrics = Metric.where(depth: params[:depth])
      @title_metrics += " [глубина данных: #{params[:depth]}]"
    else
      if params[:mtype].present?
        @metrics = Metric.where(mtype: params[:mtype])
        @title_metrics += " [тип: #{params[:mtype]}]"
      else
        @metrics = Metric.search(params[:search])
      end
    end
    @metrics = @metrics.order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
    render :index
  end

  def show
    @current_period_date = (params[:date].presence || Time.current.to_s).to_time
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
      values = MetricValue.where(metric_id: @metric.id).order('MAX(dtime) ASC').group_by_month(:dtime, range: @date1..@date2, time_zone: 'UTC').sum(:value)
    when 2 # месяц
      @format_period = '%B %Y'
      @date1 = @current_period_date.beginning_of_month
      @date2 = @current_period_date.end_of_month
      @prev_date = @date1.ago(1.month)
      @next_date = @date2.since(1.month)
      values = MetricValue.where(metric_id: @metric.id).group_by_day(:dtime, range: @date1..@date2, format: '%-d').order('MAX(dtime) ASC').sum(:value)
    when 3 # день
      @format_period = '%d.%m.%Y'
      @date1 = @current_period_date.beginning_of_day
      @date2 = @current_period_date.end_of_day
      @prev_date = @date1.ago(1.day)
      @next_date = @date2.since(1.day)
      values = MetricValue.group_by_hour(:dtime, range: @date1..@date2, format: '%H').order('MAX(dtime) ASC').sum(:value)
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
    @metric.mhash = Digest::MD5.hexdigest(rand().to_s) # для новой метрики создадим HASH по умолчанию
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
    if params[:date].presence
      @current_period_date = params[:date].to_time
    end
    @prev_period_date = @current_period_date - @current_period_date.day.days
    @next_period_date = @current_period_date.end_of_month + 1
    if @next_period_date == (Time.current.end_of_month + 1)
      @next_period_date = nil
    end
    values = MetricValue.where(metric_id: @metric.id)
    @values = case @metric.depth # список значений за выбранный период
              when 1..2 then values.where(dtime: (@current_period_date.beginning_of_year..@current_period_date.end_of_year)).order(:dtime)
      else values.where(dtime: (@current_period_date.beginning_of_month..@current_period_date.end_of_month)).order(:dtime)
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

  def set # http: GET /metrics/ID/set?v=VALUE&h=HASH
    @metric = Metric.find(params[:id])
    if @metric && params[:v].presence && params[:h].presence
      where_datetime = @metric.sql_period Time.current.utc
      value = MetricValue.where('metric_id = ?', @metric.id).where("dtime BETWEEN #{where_datetime}").first
      value = MetricValue.new(metric_id: @metric.id) unless value # не нашли - добавим новое значение
      value.dtime = Time.current # обновим время записи значения
      if Digest::MD5.hexdigest(@metric.mhash) == params[:h]
        value.value = params[:v]
        value.save
        render nothing: true, status: 200, content_type: 'text/html'
      else
        render nothing: true, status: 400, content_type: 'text/html'
      end
    else
      render nothing: true, status: 404, content_type: 'text/html'
    end
  end

  def test
    test_date = @metric.sql_period_beginning_of

    if @metric.mtype == 'MSSQL'
      require 'tiny_tds'
      c = ActiveRecord::Base.configurations['production_MSSQL']
      mssql = TinyTds::Client.new username: c['username'], password: c['password'], host: c['host'], database: c['database']
    end
    @sql = @metric.msql
    @test = 'запрос не указан!'
    if @sql
      @sql.gsub!(/\r\n?/, ' ') # заменим \n \r на пробелы

      sql_period = @metric.sql_period
      @sql.gsub!(/##PERIOD##/, sql_period) # заменим период
      sql_date = @metric.sql_period_beginning_of
      @sql.gsub!(/##DATE##/, sql_date) # заменим дату

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
      rescue => error
        logger.info "      ERR: #{@sql}"
        @test << "ERR: #{@sql}\n"
        @test << error.inspect
      ensure
        mssql.close if mssql
      end
    end
  end

  def set_values
    period_date = (params[:date].presence || Time.current.to_s).to_time
    period_date = Time.current if period_date > Time.current
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
        sql = @metric.msql.gsub(/\r\n?/, ' ') # заменим \n \r на пробелы

        sql_period = @metric.sql_period Time.at(d), depth + 1
        sql.gsub!(/##PERIOD##/, sql_period) # заменим период
        sql_date = @metric.sql_period_beginning_of Time.at(d), depth + 1
        sql.gsub!(/##DATE##/, sql_date) # заменим дату
        new_value = nil
        begin
          if @metric.mtype == 'MSSQL'
            results = mssql.execute(sql)
          elsif @metric.mtype == 'localPG'
            results = ActiveRecord::Base.connection.execute(sql)
          end
          results.each do |row|
            new_value = row['count']
          end
        rescue => error
          logger.error "      ERR: #{sql}\n#{error}"
        ensure
        end
        if new_value
          if new_value.positive?
            p Time.at(d)
            ids = MetricValue.where(metric_id: @metric.id).where("dtime BETWEEN #{sql_period}").all.ids
            p ids
            value = MetricValue.where(metric_id: @metric.id).where("dtime BETWEEN #{sql_period}").first
            p value
            value = MetricValue.new(metric_id: @metric.id) unless value # не нашли? - новое значение
            p value
            value.value = new_value
            value.dtime = Time.at(d) # обновим время записи значения
            logger.error "#{@metric.id} #{value.errors}" unless value.save
          end
        end
      end
      mssql.close if mssql
    end
    redirect_to action: :show and return
  end

  private

  def set_metric
    @metric = Metric.find(params[:id])
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
  end

  # Only allow a trusted parameter "white list" through.
  def metric_params
    params.require(:metric).permit(:bproce_id, :name, :shortname, :description, :note, :depth, :depth_name, :bproce_name, :mtype, :msql)
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
end
