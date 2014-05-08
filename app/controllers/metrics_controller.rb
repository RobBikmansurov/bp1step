class MetricsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :set_metric, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @metrics = Metric.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    graph_type = params[:type].presence || 'day'
    current_period_date = Date.today
    current_period_values = case graph_type
             when 'month' then MetricValue.by_month_totals(@metric.id, current_period_date)
             when 'week' then MetricValue.by_week_totals(@metric.id, current_period_date)
             when 'day' then MetricValue.by_day_totals(@metric.id, current_period_date)
             else {}
             end
    prev_period_date = Date.today - Date.today.day
    prev_period_values = case graph_type
             when 'month' then MetricValue.by_month_totals(@metric.id, prev_period_date)
             when 'week' then MetricValue.by_week_totals(@metric.id, prev_period_date)
             when 'day' then MetricValue.by_day_totals(@metric.id, prev_period_date)
             else {}
             end
    values = MetricValue.where(:metric_id => @metric.id).group(:dtime).sum(:value)
    @data = [{ name: 'Current', data: current_period_values },
             { name: "Prev", data: prev_period_values } ]
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
