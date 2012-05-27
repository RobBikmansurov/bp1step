class BproceWorkplacesController < ApplicationController
  respond_to :html, :json

  def new
    @bproce_workplace = BproceWorkplace.new
  end

  def create
    @bproce_workplace = BproceWorkplace.create(params[:bproce_workplace])
    flash[:notice] = "Successfully created bproce_workplace." if @bproce_workplace.save
    respond_with(@bproce_workplace.workplace)
  end
  
  def destroy
    @bproce_workplace = BproceWorkplace.find(params[:id])
    @bproce_workplace.destroy
    flash[:notice] = "Successfully destroyed bproce_workplace." if @bproce_workplace.save
    respond_with(@bproce_workplace.workplace)
  end

  def show
    @bp = Bproce.find(params[:id])
    respond_with(@workplaces = @bp.workplaces)
  end

end
