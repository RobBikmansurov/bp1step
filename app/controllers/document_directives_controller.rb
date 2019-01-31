# frozen_string_literal: true

class DocumentDirectivesController < ApplicationController
  respond_to :html, :json, :js
  before_action :authenticate_user!, only: %i[edit new create update]
  before_action :get_document_directive, except: :index

  def index
    @document_directives = DocumentDirective.paginate(per_page: 10, page: params[:page])
  end

  def show
    redirect_to(directive_path(@document_directive.directive_id)) && return
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
    @document_directive = DocumentDirective.new(document_directive_params)
    respond_to do |format|
      if @document_directive.save
        if params[:document_directive][:to_directive].present?
          puts "===\nto_directive"
          @directive = Directive.find(@document_directive.directive_id)
          format.html { redirect_to directive_path(@directive), notice: 'Document directive was successfully created.' }
          # format.html { render @directive, action: :show}
        else
          format.html { redirect_to @document_directive, notice: 'Document directive was successfully created.', format: :html }
          format.json { render json: @document_directive, status: :created, location: @document_directive }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @document_directive.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @document_directive = DocumentDirective.find(params[:id])
    respond_to do |format|
      if @document_directive.update(document_directive_params)
        format.html { redirect_to @document_directive, notice: 'Document directive was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @document_directive.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @document_directive = DocumentDirective.find(params[:id])
    # logger.debug "@document_directive = #{@document_directive.inspect}"
    # logger.debug params
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

  private

  def document_directive_params
    params.require(:document_directive).permit(:document_id, :directive_id, :directive_number, :note)
  end
end
