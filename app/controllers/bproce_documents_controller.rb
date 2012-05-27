class BproceDocumentsController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@bp = Bproce.find(params[:id])
  	respond_with(@documents = @bp.documents)
  end
end
