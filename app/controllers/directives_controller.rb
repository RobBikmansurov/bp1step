class DirectivesController < ApplicationController
  respond_to :html
  respond_to :xml
  respond_to :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update]
  before_filter :get_directive, :except => [:index, :autocomplete]

  def index
    if params[:title].present?
      @directives = Directive.where(:title => params[:title]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      if params[:body].present?
        @directives = Directive.where(:body => params[:body]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        if params[:status].present?
          @directives = Directive.where(:status => params[:status]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        else
          @directives = Directive.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        end
      end
    end
  end

  def show
    respond_with(@directive)
  end

  def autocomplete
    @directives = Directive.order(:number).where("number ilike ?", "%#{params[:term]}%")
    #render json: @directives, :only => [:id, :title, :number, :shortname, :approval]
    render json: @directives.map(&:directive_name)
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
    flash[:notice] = "Successfully destroyed directive." if @directive.destroy
    respond_with(@directive)
  end

  def document_create
    @directive = Directive.find(params[:id])
    @document_directive = @directive.document_directive.new
    render :document_create
  end

private
  def sort_column
    params[:sort] || "number"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_directive
    if params[:search].present? # это поиск
      @directives = Directive.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @directive = params[:id].present? ? Directive.find(params[:id]) : Directive.new
    end
  end
end
