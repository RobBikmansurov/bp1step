class BproceIresourcesController < ApplicationController
  respond_to :html, :xml, :json
  
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
  	@bproce_iresource = BproceIresource.find(params[:id])
  	@iresource = @bproce_iresource.iresource
  	flash[:notice] = "Successfully destroyed bproce_iresource." if @bproce_iresource.destroy
    respond_with(@iresource)
  end

  def show
  	@bproce_iresource = BproceIresource.find(params[:id])
  	@iresource = @bproce_iresource.iresource
  	#respond_with(@iresource = @bi.iresource)

  	redirect_to @iresource
  end

end
