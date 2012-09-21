class DocumentsController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction

  def index
    @documents = Document.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def edit
    @document = Document.find(params[:id])
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    @directive = @document.directive.new # заготовка для новой связи с директивой
end

  def update
    @document = Document.find(params[:id])
    user_id = @document.owner_id
    flash[:notice] = "Successfully updated document."  if @document.update_attributes(params[:document])
  end

  def show
    respond_with(@document = Document.find(params[:id]))
  end

  def new
    @document = Document.new
    respond_with(@document)
  end

  def create
    @document = Document.create(params[:document])
    flash[:notice] = "Successfully created Document." if @document.save
    respond_with(@document)
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

private  
  def sort_column  
    params[:sort] || "name"  
  end  
    
  def sort_direction  
    params[:direction] || "asc"  
  end  

end
