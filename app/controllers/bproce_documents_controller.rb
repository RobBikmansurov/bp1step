class BproceDocumentsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:edit, :new, :destroy]
  before_filter :get_bproce_document, :except => :index
  
  def create
    #@bproce_document = BproceDocument.create(params[:bproce_document])
    flash[:notice] = "Successfully created bproce_document." if @bproce_document.save
    respond_with(@bproce_document.document)
  end

  def show
  	@bproce = Bproce.find(params[:id])
  	respond_with(@documents = @bproce.documents)
  end

  def destroy
    document = @bproce_document.document
    flash[:notice] = "Successfully destroyed bproce_document." if @bproce_document.destroy
    if !@bproce.blank?
      respond_with(@bproce)
    else
      respond_with(document)
    end
  end


private

  def get_bproce_document
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @document = Document.find(params[:document_id]) if params[:document_id].present?
    logger.debug "bproce = #{@bproce.inspect}"
    logger.debug "document = #{@document.inspect}"
    @bproce_document = params[:id].present? ? BproceDocument.find(params[:id]) : BproceDocument.new(params[:bproce_document])
  end


end