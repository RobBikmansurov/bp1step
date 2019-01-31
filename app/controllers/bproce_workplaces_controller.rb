# frozen_string_literal: true

class BproceWorkplacesController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    if bproce_workplace_params[:workplace_id].present?
      @workplace = Workplace.find(bproce_workplace_params[:workplace_id])
      @bproce = Bproce.find_by(name: bproce_workplace_params[:bproce_name])
    elsif bproce_workplace_params[:bproce_id].present?
      @bproce = Bproce.find(bproce_workplace_params[:bproce_id])
      @workplace = Workplace.find_by(designation: bproce_workplace_params[:workplace_designation])
    end
    @bproce_workplace = BproceWorkplace.new(bproce_id: @bproce.id, workplace_id: @workplace.id)
    flash[:notice] = 'Рабочее место добавлено в Процесс' if @bproce_workplace.save
    if bproce_workplace_params[:workplace_id].present?
      respond_with @workplace
    else
      respond_with @bproce
    end
  end

  def destroy
    @bproce_workplace = BproceWorkplace.find(params[:id])
    flash[:notice] = 'Рабочее место удалено из Процесса' if @bproce_workplace.destroy
    if params[:bproce].present? # возврат в процесс
      @bproce = Bproce.find(params[:bproce])
      respond_with(@bproce)
    else
      # возврат в Рабочее Место
      respond_with(@bproce_workplace.workplace)
    end
  end

  def show
    @bproce = Bproce.find(params[:id])
    respond_with(@workplaces = @bproce.workplaces)
  end

  private

  def bproce_workplace_params
    params.require(:bproce_workplace).permit(:bproce_id, :workplace_id, :bproce_name, :workplace_designation)
  end
end
