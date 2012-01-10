class DocumentcoController < ApplicationController
  respond_to :html, :xml, :json
  def index
    @documents = Document.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    @document = @documents.first
  end

  def show
    @documents = Document.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    if @documents.any? {|d| d.id == params[:id]}
      @document = @documents.find(params[:id])
    else
      @document = @documents.first
    end
  end

end
