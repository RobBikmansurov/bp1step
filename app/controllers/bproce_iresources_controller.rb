class BproceIresourcesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:edit, :create]
  before_filter :get_bproce_iresource, :except => :index
  
  def create
  	@bproce_iresource = BproceIresource.new(params[:bproce_iresource])
    respond_to do |format|
      if @bproce_iresource.save
        format.html { redirect_to @bproce_iresource, notice: 'BproceIresources was successfully created.' }
        format.json { render json: @bproce_iresource, status: :created, location: @bproce_iresource }
      else
        format.html { render action: "new" }
        format.json { render json: @bproce_iresource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@iresource = @bproce_iresource.iresource
  	flash[:notice] = "Successfully destroyed bproce_iresource." if @bproce_iresource.destroy
    #respond_with(@iresource)
  end

  def show
  	@iresource = @bproce_iresource.iresource
  end

  def edit
    respond_with(@bproce_iresource)
  end

  def update
    flash[:notice] = "Successfully updated bproce_iresource." if @bproce_iresource.update_attributes(params[:bproce_iresource])
    respond_with(@bproce_iresource)
  end

private

  def get_bproce_iresource
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @bproce_iresource = params[:id].present? ? BproceIresource.find(params[:id]) : BproceIresource.new(params[:bproce_bapp])
  end


end
