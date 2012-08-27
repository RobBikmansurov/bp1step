class UserRolesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@ur = User.find(params[:id])
  	respond_with(@roles = @ur.user_roles)
  end
end
