class DocumentsController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_document, :except => :index


  def index
    @documents = Document.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def edit
    @document_directives = DocumentDirective.find_all_by_document_id(@document) # все связи документа с директивами
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    respond_with(@document)
  end

  def update
    user_id = @document.owner_id
    flash[:notice] = "Successfully updated document."  if @document.update_attributes(params[:document])
    respond_with(@document)
  end

  def show
    respond_with(@document)
  end

  def new
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    respond_with(@document)
  end

  def create
    @document = Document.new(params[:document])
    flash[:notice] = "Successfully created Document." if @document.save
    respond_with(@document)
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

private  

  def get_document
    @document = params[:id].present? ? Document.find(params[:id]) : Document.new
  end

  def sort_column  
    params[:sort] || "name"  
  end  
    
  def sort_direction  
    params[:direction] || "asc"  
  end  

end
