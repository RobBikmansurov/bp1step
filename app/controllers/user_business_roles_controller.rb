class UserBusinessRolesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	#@u = User.find(params[:id])
  	#respond_with(@business_roles = @u.business_user_roles)
    redirect_to :back
  end

  def new
    @user_business_role = UserBusinessRole.new
  end

  def create
    @user_business_role = UserBusinessRole.create(params[:user_business_role])
    @business_role = BusinessRole.find(@user_business_role.business_role_id)
    flash[:notice] = "Successfully created user_business_role." if @user_business_role.save
    respond_with(@business_role)
  end

  def destroy
    @user_business_role = UserBusinessRole.find(params[:id])
    @business_role = BusinessRole.find(@user_business_role.business_role_id)
    @user_business_role.destroy
    respond_with(@business_role)
  end

end
