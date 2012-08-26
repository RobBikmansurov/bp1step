class UsersController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @usr = User.find(params[:id])  # отображаемый пользователь
    @uroles = @usr.user_roles      # исполняет роли
    @uworkplaces = @usr.user_workplaces # рабочие места пользователя
    respond_with(@roles = @usr.roles)
  end

private
  def sort_column
    params[:sort] || "displayname"
  end

  def sort_direction
    params[:direction] || "asc"
  end

end
