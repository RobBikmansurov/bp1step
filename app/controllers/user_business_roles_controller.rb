class UserBusinessRolesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:new, :create]
  
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
    UserBusinessRoleMailer.user_create_role(@user_business_role).deliver    # оповестим нового исполнителя
    respond_with(@business_role)
  end

  def destroy
    @user_business_role = UserBusinessRole.find(params[:id])
    @business_role = BusinessRole.find(@user_business_role.business_role_id)
    UserBusinessRoleMailer.user_delete_role(@user_business_role).deliver    # оповестим бывшего исполнителя
    @user_business_role.destroy
    respond_with(@business_role)
  end

end
