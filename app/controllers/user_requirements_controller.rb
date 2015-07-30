class UserRequirementsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:new, :create, :destroy]
  
  def show
    @user_requirement = UserRequirement.find(params[:id])
    redirect_to requirement_path(@user_requirement.requirement_id) and return
  end

  def new
    @user_requirement = UserRequirement.new(status: 0)
  end

  def create
    @user_requirement = UserRequirement.new(params[:user_requirement])
    flash[:notice] = "Successfully created user_requirement." if @user_requirement.save
    respond_with(@user_requirement)
  end

  def destroy
    @user_requirement = UserRequirement.find(params[:id])   # нашли удаляемую связь
    @requirement = Requirement.find(@user_requirement.requirement_id) # запомнили требование для этой удаляемой связи
    @user_requirement.destroy   # удалили связь
    respond_with(@requirement)  # вернулись в требование
  end

end
