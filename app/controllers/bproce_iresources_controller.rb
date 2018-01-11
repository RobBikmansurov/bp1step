# frozen_string_literal: true

class BproceIresourcesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[edit create]
  before_action :bproce_iresource, except: :index

  def create
    @bproce = Bproce.find_by(name: params[:bproce_iresource_bproce])
    @bproce_iresource = BproceIresource.new(bproce_iresource_params)
    respond_to do |format|
      if @bproce_iresource.save
        format.html { redirect_to @bproce_iresource, notice: 'BproceIresources was successfully created.' }
        format.json { render json: @bproce_iresource, status: :created, location: @bproce_iresource }
      else
        format.html { render action: 'new' }
        format.json { render json: @bproce_iresource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @iresource = @bproce_iresource.iresource
    # @iresource = @bproce_iresource.iresource
    flash[:notice] = 'Successfully destroyed bproce_iresource.' if @bproce_iresource.destroy
    # respond_with(@bproce_iresource.bproce)
    respond_with(@bproce_iresource.iresource) # удаляем процесс из ресурса - поэтому возврат в ресурс
  end

  def show
    @iresource = @bproce_iresource.iresource
  end

  def edit
    respond_with(@bproce_iresource)
  end

  def update
    flash[:notice] = 'Successfully updated bproce_iresource.' if @bproce_iresource.update_attributes(bproce_iresource_params)
    respond_with(@bproce_iresource)
  end

  private

  def bproce_iresource_params
    params.require(:bproce_iresource).permit(:bproce_id, :iresource_id, :rpurpose)
  end

  def bproce_iresource
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @bproce_iresource = params[:id].present? ? BproceIresource.find(params[:id]) : BproceIresource.new(params[:bproce_bapp])
  end
end
