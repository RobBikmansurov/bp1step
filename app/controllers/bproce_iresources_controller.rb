# frozen_string_literal: true

class BproceIresourcesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[edit create destroy]
  before_action :bproce_iresource, except: :create

  def create
    @bproce = if bproce_iresource_params[:bproce_id].present?
                Bproce.find(bproce_iresource_params[:bproce_id])
              else
                Bproce.find_by(name: bproce_iresource_params[:bproce_name])
              end
    @iresource = if bproce_iresource_params[:iresource_id].present?
                   Iresource.find(bproce_iresource_params[:iresource_id])
                 else
                   Iresource.find_by(label: bproce_iresource_params[:iresource_label])
                 end
    @bproce_iresource = BproceIresource.new(bproce_id: @bproce.id,
                                            iresource_id: @iresource.id,
                                            rpurpose: bproce_iresource_params[:rpurpose])
    if @bproce_iresource.save
      if bproce_iresource_params[:iresource_id].present?
        flash[:notice] = "Ресурс добавлен в процесс [#{@bproce.name}]"
        respond_with @iresource
      else
        flash[:notice] = "В процесс добавлен ресурс[#{@iresource.label}]"
        respond_with @bproce if bproce_iresource_params[:bproce_id].present?
      end
    else
      render action: 'new'
    end
  end

  def destroy
    @iresource = @bproce_iresource.iresource
    flash[:notice] = 'Ресурс удален из процесса' if @bproce_iresource.destroy
    if params[:bproce].present? # возврат в процесс
      @bproce = Bproce.find(params[:bproce])
      respond_with(@bproce)
    else
      respond_with(@bproce_iresource.iresource) # удаляем процесс из ресурса - поэтому возврат в ресурс
    end
  end

  def show
    @iresource = @bproce_iresource.iresource
  end

  def edit
    respond_with(@bproce_iresource)
  end

  def update
    flash[:notice] = 'Successfully updated bproce_iresource.' if @bproce_iresource.update(bproce_iresource_params)
    respond_with(@bproce_iresource)
  end

  private

  def bproce_iresource_params
    params.require(:bproce_iresource).permit(:bproce_id, :iresource_id, :rpurpose, :bproce_name, :iresource_label)
  end

  def bproce_iresource
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @bproce_iresource = params[:id].present? ? BproceIresource.find(params[:id]) : BproceIresource.new(params[:bproce_bapp])
  end
end
