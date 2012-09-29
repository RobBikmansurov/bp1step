class BappsController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_bapp, :except => :index

  def index
    @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
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
    if flash[:bapp]
      @bapp = flash[:bapp]
    else
      @bapp = Bapp.find(params[:id])
      @bproce_bapp = BproceBapp.new(:bapp_id => @bapp.id)
    end
  end

  def update
    flash[:notice] = "Successfully updated bapp."  if @bapp.update_attributes(params[:bapp])
    #Rails.logger.debug("update-bproce_bapp: #{@bproce_bapp.inspect}")
    #Rails.logger.debug("update-bapp: #{@bapp.inspect}")
    if !@bapp.save # there was an error!
      flash[:bapp] = @bapp
      redirect_to :action => :edit
    end
    #redirect_to :action => :edit
    redirect_to :action => :index  # пойдем сразу на список Приложений
    #respond_with(@bapp)
  end

  def destroy
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
  
  def get_bapp
    @bapp = params[:id].present? ? Bapp.find(params[:id]) : Bapp.new
  end

end
