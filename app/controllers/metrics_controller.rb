class MetricsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :set_metric, only: [:show, :edit, :update, :destroy, :values, :new_value]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @title_metrics = "Метрики процессов"
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
    @metrics = @metrics.order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    if params[:date].presence
      @current_period_date = params[:date].to_time
    else
      @current_period_date = Time.current.beginning_of_month #  по умолчанию - текущий период
    end
    if params[:depth].presence
      @current_depth = params[:depth]
    else
      @current_depth = @metric.depth - 1  # по умолчанию график с группировкой значений
    end
    @current_period_values = case @current_depth.to_i
      when 2 then MetricValue.by_day_totals(@metric.id, @current_period_date)
      when 1 then MetricValue.by_month_totals(@metric.id, @current_period_date)
      else MetricValue.by_year_totals(@metric.id, @current_period_date)
    end
    @average_value = case @metric.depth  # среднее значение за выбранный период
      when 1 then MetricValue.where(:metric_id => @metric.id).where(dtime: (@current_period_date.beginning_of_year..@current_period_date.end_of_year)).average(:value)
      when 2 then MetricValue.where(:metric_id => @metric.id).where(dtime: (@current_period_date.beginning_of_year..@current_period_date.end_of_year)).average(:value)
      else MetricValue.where(:metric_id => @metric.id).where(dtime: (@current_period_date.beginning_of_month..@current_period_date.end_of_month)).average(:value)
    end

    @prev_period_date = @current_period_date - @current_period_date.day
    @next_period_date = @current_period_date.end_of_month + 1
    if @next_period_date == (Time.current.end_of_month + 1)
      @next_period_date = nil
    end
    #values = MetricValue.where(:metric_id => @metric.id).group(:dtime).sum(:value)
    @data = [ { name: @current_period_date.strftime('%b %Y'), data: @current_period_values } ]
    @metrics = Metric.where(bproce_id: @metric.bproce).order(:name)
    respond_with @data
  end

  def new
    @metric = Metric.new
  end

  def edit
  end

  def create
    @metric = Metric.new(metric_params)
    @metric.mhash = Digest::MD5.hexdigest(rand().to_s)  # для новой метрики создадим HASH по умолчанию
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
    @values = case @metric.depth  # список значений за выбранный период
      when 1 then MetricValue.where(:metric_id => @metric.id).where(dtime: (@current_period_date.beginning_of_year..@current_period_date.end_of_year)).order(:dtime)
      when 2 then MetricValue.where(:metric_id => @metric.id).where(dtime: (@current_period_date.beginning_of_year..@current_period_date.end_of_year)).order(:dtime)
      else MetricValue.where(:metric_id => @metric.id).where(dtime: (@current_period_date.beginning_of_month..@current_period_date.end_of_month)).order(:dtime)
    end
    @datetime_format = case @metric.depth  # формат отображения даты значений выбранного периода
      when 1 then '%Y'
      when 2 then '%b %Y'
      else '%d %m %Y'
    end
    @metrics = Metric.where(bproce_id: @metric.bproce).order(:name)
  end

  def new_value
    @metric_value = MetricValue.new()  # заготовка для нового значения
    @metric_value.metric_id = @metric.id
    @metric_value.dtime = params[:dtime] if params[:dtime].present?
    render 'metric_values/new'
  end

  def set   # http: GET /metrics/ID/set?v=VALUE&h=HASH
    @metric = Metric.find(params[:id])
    p params.inspect
    p params[:v].presence
    p params[:h].presence
    if @metric and params[:v].presence and params[:h].presence
      where_datetime = case @metric.depth
        when 1 then "'#{Time.current.beginning_of_year}' AND '#{Time.current.end_of_year}'"   # текущий год
        when 2 then "'#{Time.current.beginning_of_month}' AND '#{Time.current.end_of_month}'" # текущий месяц
        when 3 then "'#{Time.current.beginning_of_day}' AND '#{Time.current.end_of_day}'"     # текущий день
        else "'#{Time.current.beginning_of_hour}' AND '#{Time.current.end_of_hour}'"          # текущий час
      end
      value = MetricValue.where(metric_id: @metric.id).where("dtime BETWEEN #{where_datetime}").first
      if !value  # не нашли?
        value = MetricValue.new()  # новое значение
        value.metric_id = @metric.id
      end
      value.dtime = Time.current  # обновим время записи значения
      p value.inspect
      if Digest::MD5.hexdigest(@metric.mhash) == params[:h]
        value.value = params[:v]
        value.save
        render :nothing => true, :status => 200, :content_type => 'text/html'
      else
        render :nothing => true, :status => 400, :content_type => 'text/html'
      end
    else
      render :nothing => true, :status => 404, :content_type => 'text/html'
    end
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
      params[:sort] || "id"
    end

    def sort_direction
      params[:direction] || "asc"
    end

    def record_not_found
      flash[:alert] = "Метрика ##{params[:id]} не найдена."
      redirect_to action: :index
    end

end
