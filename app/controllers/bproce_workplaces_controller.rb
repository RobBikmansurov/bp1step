class BproceWorkplacesController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @bproce_workplace = BproceWorkplace.create(params[:bproce_workplace])
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

end
