class RolesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_role, :except => :index

  def index
    @roles = Role.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    respond_with(@role)
  end

  def create
    @role = Role.new(params[:role])
    flash[:notice] = "Successfully created role." if @role.save
    respond_with(@role)
  end

  def show
    respond_with(@role = Role.find(params[:id]))
  end

  def edit
    respond_with(@role)
  end

  def update
    flash[:notice] = "Successfully updated role." if @role.update_attributes(params[:role])
    respond_with(@role)
  end

  def destroy
    @role.destroy
    flash[:notice] = "Successfully destroyed role." if @role.save
    respond_with(@role)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
  def get_role
    @role = params[:id].present? ? Role.find(params[:id]) : Role.new
  end

end
