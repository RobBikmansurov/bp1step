class BprocesController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_bproce, :except => :index

  def index
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    respond_with(@bproce)
  end

  def new
    respond_with(@bproce)
  end

  def edit
    @role = Role.new(:bproce_id => @bproce.id)
  end

  def create
    @bproce = Bproce.new(params[:bproce])
    flash[:notice] = "Bproce was successfully created." if @bproce.save
    respond_with(@bproce)
  end

  def update
    @role = Role.new(params[:role])
    @role.save if !@role.nil
    flash[:notice] = "Successfully updated Bproce." if @bproce.update_attributes(params[:bproce])
    respond_to(@bproces)
  end

  def destroy
    @bproce.destroy
    respond_with(@bproce)
  end

private
  def sort_column
    params[:sort] || "lft"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_bproce
    @bproce = params[:id].present? ? Bproce.find(params[:id]) : Bproce.new
  end

end
