class BappsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    @bapp = Bapp.new
    respond_with(@bapp)
  end

  def create
    @bapp = Bapp.create(params[:bapp])
    flash[:notice] = "Successfully created bapp." if @bapp.save
    respond_with(@bapp)
  end

  def show
    respond_with(@bapp = Bapp.find(params[:id]))
  end

  def edit
    @bapp = Bapp.find(params[:id])
    @bproce_bapp = BproceBapp.new
    #@bproce_bapp.build
    #@bapp.update_attributes(params[:bproce]) ?
    #  redirect_to(bapp_path(@bapp)) : render(:action => :edit)
  end

  def update
    @bapp = Bapp.find(params[:id])
    flash[:notice] = "Successfully updated bapp."  if @bapp.update_attributes(params[:bapp])
    respond_with(@bapp)
  end

  def destroy
    @bapp = Bapp.find(params[:id])
    @bapp.destroy
    flash[:notice] = "Successfully destroyed bapp." if @bapp.save
    respond_with(@bapp)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end


end
