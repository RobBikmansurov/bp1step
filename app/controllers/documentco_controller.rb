class DocumentcoController < ApplicationController
  respond_to :html, :xml, :json
  def index
    @documents = Document.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    @document = @documents.first
  end

  def show
    @documents = Document.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
<<<<<<< HEAD
    if @documents.any? {|d| d.id == :id}
      @document = @documents.find(params[:id])
    else
      @document = @documents.first
    end 
=======
    @document = @documents.find(params[:id])
>>>>>>> f74bfabb6be8b7164a363cd348ead46c7d784fd0
  end

end
