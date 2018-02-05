# frozen_string_literal: true

class BproceBappsController < ApplicationController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit new]
  before_action :bproce_bapp, except: %i[index create]

  def create
    # bproce_bapp = logger.debug "params = #{params[:bproce_bapp_bproce_id]}"
    @bproce = Bproce.find_by(name: params[:iresource_bproce_id])
    @bproce_bapp = BproceBapp.new(bproce_bapp_params)
    if @bproce_bapp.save
      flash[:notice] = 'Successfully created bproce_bapp.'
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
    flash[:notice] = 'Successfully destroyed bproce_bapp.' if @bproce_bapp.destroy
    if @bproce.present?
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
      @bproce_bapp = BproceBapp.paginate(per_page: 10, page: params[:page])
    end
  end

  def update
    flash[:notice] = 'Successfully updated bproce_bapp.' if @bproce_bapp.update_attributes(bproce_bapp_params)
    respond_with(@bproce_bapp)
  end

  private

  def bproce_bapp_params
    params.require(:bproce_bapp).permit(:bproce_id, :bapp_id, :apurpose)
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def bproce_bapp
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @bproce_bapp = params[:id].present? ? BproceBapp.find(params[:id]) : BproceBapp.new(bproce_bapp_params)
  end
end
