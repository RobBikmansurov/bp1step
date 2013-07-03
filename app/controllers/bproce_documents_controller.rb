class BproceDocumentsController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@bproce = Bproce.find(params[:id])
  	respond_with(@documents = @bproce.documents)
  end
end