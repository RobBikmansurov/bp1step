class UserWorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:new, :create, :destroy]
  
  def show
    @user_workplace = UserWorkplace.find(params[:id])   # нашли удаляемую связь
    redirect_to workplace_path(@user_workplace.workplace_id) and return
  end

  def new
    @user_workplace = UserWorkplace.new
  end

  def create
    @user_workplace = UserWorkplace.create(params[:user_workplace])
    flash[:notice] = "Successfully created user_workplace." if @user_workplace.save
    respond_with(@user_workplace)
  end

  def destroy
    @user_workplace = UserWorkplace.find(params[:id])   # нашли удаляемую связь
    @workplace = Workplace.find(@user_workplace.workplace_id) # запомнили рабочее место для этой удаляемой связи
    @user_workplace.destroy   # удалили связь
    respond_with(@workplace)  # вернулись в рабочее место
  end

end
