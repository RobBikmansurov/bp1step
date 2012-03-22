class BappsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    @bapp = Bapp.new
    @bproce_bapp = BproceBapp.new
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
    #@bproce_bapps = @bapp.bproces
    #@bproce_bapp.bapp_id = @bapp.id
    #render :text => @bproce_bapp.inspect
    #Rails.logger.debug("bproce_bapp: #{@bproce_bapp.inspect}")
    #@bproce_bapp.build
    if flash[:bapp]
      @bapp = flash[:bapp]
    else
      @bapp = Bapp.find(params[:id])
      @bproce_bapp = BproceBapp.new(:bapp_id => @bapp.id)
    end
    #redirect_to(@bapp) @bproce_bapp.update_attributes(params[:bproce_bapp]) ?
    #Rails.logger.debug("edit-bproce_bapp: #{@bproce_bapp.inspect}")
    #Rails.logger.debug("edit-bapp: #{@bapp.inspect}")
  end

  def update
    @bapp = Bapp.find(params[:id])
    flash[:notice] = "Successfully updated bapp."  if @bapp.update_attributes(params[:bapp])
    respond_with(@bapp)
    #Rails.logger.debug("update-bproce_bapp: #{@bproce_bapp.inspect}")
    #Rails.logger.debug("update-bapp: #{@bapp.inspect}")
    if !@bapp.save # there was an error!
      flash[:bapp] = @bapp
      redirect_to :action => :edit
    end
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
