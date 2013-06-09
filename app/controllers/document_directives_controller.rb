class DocumentDirectivesController < ApplicationController
  respond_to :html
  before_filter :get_document_directive, :except => :index

  def index
    @document_directives = DocumentDirective.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    respond_with(@document_directive)
    #redirect_to :back   # сделан возврат,т.к не смог по-другому реализовать возврат в документ после добавления диретктивы
  end

  def new
    @document_directive = DocumentDirective.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document_directive }
    end
  end

  def edit
    @document_directive = DocumentDirective.find(params[:id])
  end

  def create
    @document_directive = DocumentDirective.new(params[:document_directive])
    respond_to do |format|
      if @document_directive.save
        format.html { redirect_to @document_directive, notice: 'Document directive was successfully created.' }
        format.json { render json: @document_directive, status: :created, location: @document_directive }
      else
        format.html { render action: "new" }
        format.json { render json: @document_directive.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @document_directive = DocumentDirective.find(params[:id])
    respond_to do |format|
      if @document_directive.update_attributes(params[:document_directive])
        format.html { redirect_to @document_directive, notice: 'Document directive was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @document_directive.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #@document_directive = DocumentDirective.find(params[:id])
    #logger.debug "@document_directive = #{@document_directive.inspect}"
    #logger.debug params
    @directive = Directive.find(@document_directive.directive_id) # запомнили директиву, для которой удаляется связь с документом
    @document = Document.find(@document_directive.document_id)    # запомнили документ, для которого удаляется связь с директивой
    @document_directive.destroy
    respond_to do |format|
      format.html { redirect_to @document, notice: 'Document directive was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def get_document_directive
    @document_directive = params[:id].present? ? DocumentDirective.find(params[:id]) : DocumentDirective.new
  end


end