class UserWorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	#@uw = User.find(params[:id])
  	#respond_with(@workplaces = @uw.workplaces)
    redirect_to :back
  end

  def new
    @user_workplace = UserWorkplace.new
  end

  def create
    @user_workplace = UserWorkplace.create(params[:user_workplace])
    flash[:notice] = "Successfully created user_workplace." if @user_workplace.save
    respond_with(@user_workplace)
  end

end
