# coding: utf-8
class UsersController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @usr = User.find(params[:id])     # отображаемый пользователь
    @uroles = @usr.user_business_role   # исполняет роли
    @uworkplaces = @usr.user_workplace 	# рабочие места пользователя
    @documents = Document.find_all_by_responsible(@usr)
    respond_with()
  end

  def edit
    @usr = User.find(params[:id])     # отображаемый пользователь
  end

  def update
    @usr = User.find(params[:id])
    if @usr.update_attributes(params[:user])
      redirect_to @usr, notice: "Successfully created user access roles."
    else
      render :edit
    end
    #@usr = User.find(params[:id])
    #if params[:role].present?
      #@business_role = Role.new(params[:business_role])
      #@user_role.save if !@user_role.nil?
    #end
    #redirect_to :action => :edit
  end


private
  def sort_column
    params[:sort] || "displayname"
  end

  def sort_direction
    params[:direction] || "asc"
  end

end
