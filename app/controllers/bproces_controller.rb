class BprocesController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction

  def index
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @bproce = Bproce.find(params[:id])
    respond_with(@bproce)
  end

  def new
    @bproce = Bproce.new
    respond_with(@bproce)
  end

  def edit
    @bproce = Bproce.find(params[:id])
    @role = Role.new(:bproce_id => @bproce.id)
  end

  def create
    @bproce = Bproce.new(params[:bproce])
    flash[:notice] = "Bproce was successfully created." if @bproce.save
    respond_with(@bproce)
  end

  def update
    @bproce = Bproce.find(params[:id])
    @role = Role.new(params[:role])
    @role.save if @role.id
    flash[:notice] = "Successfully updated Bproce."  if @bproce.update_attributes(params[:bproce])
    respond_with(@bproce)
  end

  def destroy
    @bproce = Bproce.find(params[:id])
    @bproce.destroy
    flash[:notice] = "Successfully destroyed Bproce." if @bproce.save
    respond_with(@bproce)
  end

private
  def sort_column
    params[:sort] || "lft"
  end

  def sort_direction
    params[:direction] || "asc"
  end


end
