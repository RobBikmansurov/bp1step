class RolesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @roles = Role.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    @role = Role.new
    respond_with($role)
  end

  def create
    @role = Role.create(params[:role])
    flash[:notice] = "Successfully created role." if $role.save
    respond_with(@role)
  end

  def show
    respond_with(@role = Role.find(params[:id]))
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    flash[:notice] = "Successfully updated role."  if $role.update_attributes(params[:role])
    respond_with(@role)
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    flash[:notice] = "Successfully destroyed role." if $role.save
    respond_with(@role)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end


end
