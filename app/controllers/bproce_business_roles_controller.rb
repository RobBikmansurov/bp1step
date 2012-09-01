class BproceBusinessRolesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@bp = Bproce.find(params[:id])
  	respond_with(@business_roles = @bp.business_roles)
  end
end
