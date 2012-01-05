class DocumentcoController < ApplicationController
  respond_to :html, :xml, :json
  def index
    @documents = Document.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    @document = @documents.first
  end

  def show
    @documents = Document.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    @document = @documents.find(params[:id])
  end

end
