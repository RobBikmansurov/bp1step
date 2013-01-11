# coding: utf-8
class UsersController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_user, :except => :index

  def index
    if params[:role].present?
      @role = Role.find_by_name(params[:role])
      @users = @role.users.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    end
  end

  def show
    @uroles = @usr.user_business_role   # исполняет роли
    @uworkplaces = @usr.user_workplace 	# рабочие места пользователя
    @documents = Document.find_all_by_responsible(@usr)
    respond_with()
  end

  def edit
  end

  def update
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

  def get_user
    if params[:search].present? # это поиск
      @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @usr = params[:id].present? ? User.find(params[:id]) : User.new
    end
  end

end
