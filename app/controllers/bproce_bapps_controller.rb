class BproceBappsController < ApplicationController
  # TODO редактировать назначение Приложения в Процессе (пока есть только создание/удаление из Процесса)
  respond_to :html, :json

  def new
    @bproce_bapp = BproceBapp.new
  end

  def create
    @bproce_bapp = BproceBapp.create(params[:bproce_bapp])
    flash[:notice] = "Successfully created bproce_bapp." if @bproce_bapp.save
    respond_with(@bproce_bapp.bapp)
  end
  
  def destroy
    @bproce_bapp = BproceBapp.find(params[:id])
    @bproce_bapp.destroy
    flash[:notice] = "Successfully destroyed brpoce_bapp." if @bproce_bapp.save
    respond_with(@bproce_bapp.bapp)
  end

  def show
    @bp = Bproce.find(params[:id])  # нужный процесс
    @bapps = @bp.bapps # приложения
    respond_with(@bpapps = @bp.bproce_bapps)  # приложения процесса
  end

end
