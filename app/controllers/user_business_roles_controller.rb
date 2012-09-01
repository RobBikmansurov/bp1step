class UserBusinessRolesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@u = User.find(params[:id])
  	respond_with(@business_roles = @u.business_user_roles)
  end
end
