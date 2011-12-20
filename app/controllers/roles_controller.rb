class RolesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @roles = Role.search(params[:search], params[:page])
    respond_with($roles)
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
    respond_with(@role)
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
end
