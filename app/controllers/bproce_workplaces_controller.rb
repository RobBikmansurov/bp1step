# frozen_string_literal: true

class BproceWorkplacesController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @bproce_workplace = BproceWorkplace.create(bproce_workplace_params)
    flash[:notice] = 'Successfully created bproce_workplace.' if @bproce_workplace.save
    respond_with(@bproce_workplace.workplace)
  end

  def destroy
    @bproce_workplace = BproceWorkplace.find(params[:id])
    flash[:notice] = 'Successfully destroyed bproce_workplace.' if @bproce_workplace.destroy
    respond_with(@bproce_workplace.workplace)
  end

  def show
    @bproce = Bproce.find(params[:id])
    respond_with(@workplaces = @bproce.workplaces)
  end

  private

  def bproce_workplace_params
    params.require(:bproce_workplace).permit(:bproce_id, :workplace_id)
  end
end
