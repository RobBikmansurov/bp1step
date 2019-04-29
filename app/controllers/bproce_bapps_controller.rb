# frozen_string_literal: true

class BproceBappsController < ApplicationController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit create]
  before_action :bproce_bapp

  def create
    if bproce_bapp_params[:bproce_name].present?
      # добавляем процесс по имени к приложению
      @bproce = Bproce.find_by(name: bproce_bapp_params[:bproce_name])
      @bapp = Bapp.find(bproce_bapp_params[:bapp_id])
    elsif bproce_bapp_params[:bapp_name].present?
      # добавляем приложение по имени к процессц
      @bapp = Bapp.find_by(name: bproce_bapp_params[:bapp_name])
      @bproce = Bproce.find(bproce_bapp_params[:bproce_id])
    end
    @bproce_bapp = BproceBapp.new(bproce_bapp_params)
    @bproce_bapp.bproce_id = @bproce.id
    @bproce_bapp.bapp_id = @bapp.id
    if @bproce_bapp.save
      if bproce_bapp_params[:bproce_name].present?
        flash[:notice] = "Приложение добавлено в процесс [#{@bproce.name}]"
        respond_with @bapp
      else
        flash[:notice] = "Приложение [#{@bproce_bapp.bapp.name}] добавлено в процесс"
        respond_with @bproce
      end
    else
      respond_with(@bproce_bapp)
    end
  end

  def edit
    respond_with(@bproce_bapp)
  end

  def destroy
    bapp = @bproce_bapp.bapp
    flash[:notice] = 'Приложение удалено из процесса' if @bproce_bapp.destroy
    if params[:bproce].present? # возврат в процесс
      @bproce = Bproce.find(params[:bproce])
      respond_with(@bproce)
    else
      # возврат в приложение
      respond_with(bapp)
    end
  end

  def show
    @bp = Bproce.find(@bproce_bapp.bproce.id)
    respond_with(@bproce_bapp)
  end

  def update
    flash[:notice] = 'Successfully updated bproce_bapp.' if @bproce_bapp.update(bproce_bapp_params)
    respond_with(@bproce_bapp)
  end

  private

  def bproce_bapp_params
    params.require(:bproce_bapp).permit(:bproce_id, :bapp_id, :apurpose, :bapp_name, :bproce_name)
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
