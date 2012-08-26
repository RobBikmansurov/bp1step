class UserRolesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@ur = User.find(params[:id])
  	respond_with(@roles = @ur.roles)
  end
end
