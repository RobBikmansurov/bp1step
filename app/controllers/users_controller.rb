class UsersController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    #@user = params[:id].present? ? User.find(params[:id]) : user.new
    respond_with(@user = User.find(params[:id]))
  end

private
  def sort_column
    params[:sort] || "displayname"
  end

  def sort_direction
    params[:direction] || "asc"
  end

end
