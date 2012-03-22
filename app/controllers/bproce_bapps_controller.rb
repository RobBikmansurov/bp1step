class BproceBappsController < ApplicationController
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

end
