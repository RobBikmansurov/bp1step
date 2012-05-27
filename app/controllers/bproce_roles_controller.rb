class BproceRolesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@bp = Bproce.find(params[:id])
  	respond_with(@roles = @bp.roles)
  end
end
