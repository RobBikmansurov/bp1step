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

private
  def sort_column
    params[:sort] || "displayname"
  end

  def sort_direction
    params[:direction] || "asc"
  end

end
