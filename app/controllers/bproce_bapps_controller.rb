class BproceBappsController < ApplicationController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_bapp, :except => :index

  def new
    @bproce_bapp = BproceBapp.new
  end

  def create
    flash[:notice] = "Successfully created bproce_bapp." if @bproce_bapp.save
    respond_with(@bproce_bapp.bapp)
  end

  def edit
    respond_with(@bproce_bapp)
  end
  
  def destroy
    @bproce_bapp.destroy
    flash[:notice] = "Successfully destroyed brpoce_bapp." if @bproce_bapp.save
    respond_with(@bproce_bapp.bapp)
  end

  def show
    respond_with(@bproce_bapp)
  end

  def index
    @bproce_bapp = BproceBapp.all #.paginate(:per_page => 10, :page => params[:page])
  end

  def update
    flash[:notice] = "Successfully updated bproce_bapp." if @bproce_bapp.update_attributes(params[:bproce_bapp])
    respond_with(@bproce_bapp)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_bapp
    @bproce_bapp = params[:id].present? ? BproceBapp.find(params[:id]) : BproceBapp.new
  end
  

end
