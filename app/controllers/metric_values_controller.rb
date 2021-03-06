# frozen_string_literal: true

class MetricValuesController < ApplicationController
  respond_to :html, :xml, :json

  before_action :set_metric_value, only: %i[edit update destroy]

  # rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def edit; end

  def update
    if @metric_value.update(metric_value_params)
      redirect_to metric_url(@metric) + '/values', notice: 'Metric value was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @metric_value.destroy
    redirect_to metric_url(@metric_value.metric_id) + '/values', notice: 'Metric value was successfully destroyed.'
  end

  def create
    @metric_value = MetricValue.new(metric_value_params)
    @metric = Metric.find(@metric_value.metric_id)
    if @metric_value.save
      redirect_to metric_url(@metric_value.metric_id) + '/values', notice: 'Metric Value was successfully created.'
    else
      render action: 'new'
    end
  end

  private

  def set_metric_value
    @metric_value = MetricValue.find(params[:id])
    @metric = Metric.find(@metric_value&.metric_id)
  end

  def metric_value_params
    params.require(:metric_value).permit(:id, :dtime, :value, :metric_id)
  end

  def record_not_found
    flash[:alert] = 'Неверный #id, Метрика не найдена.'
    redirect_to action: :index
  end
end
