class DirectivesController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_directive, :except => :index

  def index
    @directives = Directive.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    respond_with(@directive)
  end

  def new
    @document_directive = @directive.document_directive.new # заготовка для новой связи с документом
    respond_with(@directive)
  end

  def edit
    @document_directive = @directive.document_directive.new # заготовка для новой связи с документом
    respond_with(@directive)
  end

  def create
    @directive = Directive.new(params[:directive])
    flash[:notice] = "Successfully created directive." if @directive.save
    respond_with(@directive)
  end

  def update
    flash[:notice] = "Successfully updated directive." if @directive.update_attributes(params[:directive])
    respond_with(@directive)
  end

  def destroy
    @directive.destroy
    flash[:notice] = "Successfully destroyed directive." if @directive.update_attributes(params[:directive])
    respond_with(@directive)
  end

private
  def sort_column
    params[:sort] || "number"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_directive
    @directive = params[:id].present? ? Directive.find(params[:id]) : Directive.new
  end
end
