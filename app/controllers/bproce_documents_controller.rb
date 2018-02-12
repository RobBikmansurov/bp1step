# frozen_string_literal: true

class BproceDocumentsController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[edit new destroy]
  before_action :bproce_document, except: %i[index show]

  def new
    @bproce_document = BproceDocument.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bproce_document }
    end
  end

  def create
    @bproce_document = BproceDocument.create(bproce_document_params)
    flash[:notice] = 'Successfully created bproce_document.' if @bproce_document.save
    respond_with(@bproce_document.document)
  end

  def show
    @bproce_document = BproceDocument.find(params[:id])
    @bproce = Bproce.find(@bproce_document.bproce_id)
    respond_with(@bproce_documents = @bproce.bproce_documents)
  end

  def destroy
    processes = BproceDocument.where(document_id: @bproce_document.document_id).count
    if processes > 1
      flash[:notice] = "Документ удален из процесса ##{@bproce_document.bproce_id}" if @bproce_document.destroy
    else
      flash[:alert] = 'Нельзя удалить единственный процесс из документа!'
    end
    respond_with(@bproce_document.document) # вернемся в документ
  end

  def edit
    respond_with(@bproce_document)
  end

  def update
    flash[:notice] = 'Successfully updated bproce_document.' if @bproce_document.update_attributes(bproce_document_params)
    respond_with(@bproce_document)
  end

  private

  def bproce_document_params
    params.require(:bproce_document).permit(:document_id, :bproce_id, :purpose, :bproce_name)
  end

  def bproce_document
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @document = Document.find(params[:document_id]) if params[:document_id].present?
    @bproce_document = params[:id].present? ? BproceDocument.find(params[:id]) : BproceDocument.new(bproce_document_params)
  end
end
