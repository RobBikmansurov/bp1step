class BproceBappsController < ApplicationController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:edit, :new]
  before_filter :get_bproce_bapp, :except => [:index, :create]

  def create
    #bproce_bapp = logger.debug "params = #{params[:bproce_bapp_bproce_id]}"
    @bproce = Bproce.find_by_name(params[:iresource_bproce_id])
    @bproce_bapp = BproceBapp.new(params[:bproce_bapp])
    if @bproce_bapp.save
      flash[:notice] = "Successfully created bproce_bapp."
      redirect_to(@bproce_bapp.bapp)
    else
      respond_with(@bproce_bapp)
    end
  end

  def edit
    respond_with(@bproce_bapp)
  end
  
  def destroy
    bapp = @bproce_bapp.bapp
    flash[:notice] = "Successfully destroyed bproce_bapp." if @bproce_bapp.destroy
    if !@bproce.blank?
      respond_with(@bproce)
    else
      respond_with(bapp)
    end
  end

  def show
    @bp = Bproce.find(@bproce_bapp.bproce.id)
    respond_with(@bproce_bapp)
  end

  def index
    if params[:bproce_id].present?
      @bproce = Bproce.find(params[:bproce_id])
      @bproce_bapp = @bproce.bapps
    else
      @bproce_bapp = BproceBapp.paginate(:per_page => 10, :page => params[:page])
    end
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

  def get_bproce_bapp
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @bproce_bapp = params[:id].present? ? BproceBapp.find(params[:id]) : BproceBapp.new(params[:bproce_bapp])
  end
  
end
