class BproceDocumentsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:edit, :new, :destroy]
  before_filter :get_bproce_document, :except => [ :index, :show ]
  
  def create
    #@bproce_document = BproceDocument.create(params[:bproce_document])
    flash[:notice] = "Successfully created bproce_document." if @bproce_document.save
    respond_with(@bproce_document.document)
  end

  def show
    @bproce_document = BproceDocument.find(params[:id])
    @bproce = Bproce.find(@bproce_document.bproce_id)
    respond_with(@bproce_documents = @bproce.bproce_documents)
  end

  def destroy
    document = @bproce_document.document
    logger.debug "document = #{document.inspect}"
    logger.debug "@bproce_document = #{@bproce_document.inspect}"
    if document.bproce.count > 1
      flash[:notice] = "Successfully destroyed bproce_document." if @bproce_document.destroy
    else
      flash[:alert] = "Error destroyed bproce_document."
    end
    if !@bproce.blank?
      respond_with(@bproce)
    else
      respond_with(document)
    end
  end

  def edit
    respond_with(@bproce_document)
  end

  def update
    flash[:notice] = "Successfully updated bproce_document." if @bproce_document.update_attributes(params[:bproce_document])
    respond_with(@bproce_document)
  end


private

  def get_bproce_document
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @document = Document.find(params[:document_id]) if params[:document_id].present?
    @bproce_document = params[:id].present? ? BproceDocument.find(params[:id]) : BproceDocument.new(params[:bproce_document])
  end


end