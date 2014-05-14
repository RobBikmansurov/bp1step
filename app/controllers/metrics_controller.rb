class MetricsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :set_metric, only: [:show, :edit, :update, :destroy, :values, :new_value]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @metrics = Metric.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @current_period_date = Date.today # по умолчанию - текущий период
    if params[:date].presence
      @current_period_date = params[:date].to_date
    end
    @current_depth = @metric.depth - 1  # по умолчанию график с группировкой значений
    if params[:depth].presence
      @current_depth = params[:depth]
    end
    #graph_type = params[:mo].presence || 'day'
    #current_period_values = case graph_type
             #when 'month' then MetricValue.by_month_totals(@metric.id, current_period_date)
             #when 'week' then MetricValue.by_week_totals(@metric.id, current_period_date)
             #when 'day' then MetricValue.by_day_totals(@metric.id, current_period_date)
             #else {}
             #end
    current_period_values = case @current_depth.to_i
      when 2 then MetricValue.by_day_totals(@metric.id, @current_period_date)
      when 1 then MetricValue.by_month_totals(@metric.id, @current_period_date)
      else MetricValue.by_year_totals(@metric.id, @current_period_date)
    end
    #current_period_values = MetricValue.by_day_totals(@metric.id, @current_period_date)
    #current_period_values = MetricValue.by_month_totals(@metric.id, @current_period_date)
    @prev_period_date = @current_period_date - @current_period_date.day
    @next_period_date = @current_period_date.end_of_month + 1
    if @next_period_date == (Date.today.end_of_month + 1)
      @next_period_date = nil
    end
    #values = MetricValue.where(:metric_id => @metric.id).group(:dtime).sum(:value)
    @data = [ { name: @current_period_date.strftime('%b %Y'), data: current_period_values } ]
    respond_with @data
  end

  def new
    @metric = Metric.new
  end

  def edit
  end

  def create
    @metric = Metric.new(metric_params)

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
    @current_period_date = Date.today
    if params[:date].presence
      @current_period_date = params[:date].to_date
    end
    @prev_period_date = @current_period_date - @current_period_date.day
    @next_period_date = @current_period_date.end_of_month + 1
    if @next_period_date == (Date.today.end_of_month + 1)
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
  end

  def new_value
    @metric_value = MetricValue.new()  # заготовка для новго значения
    @metric_value.metric_id = @metric.id
    @metric_value.dtime = Date.today
    render 'metric_values/new'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric
      @metric = Metric.find(params[:id])
      @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    end

    # Only allow a trusted parameter "white list" through.
    def metric_params
      params.require(:metric).permit(:bproce_id, :name, :shortname, :description, :note, :depth, :bproce_name)
    end

    def sort_column
      params[:sort] || "id"
    end

    def sort_direction
      params[:direction] || "asc"
    end

end
