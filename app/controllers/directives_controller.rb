# frozen_string_literal: true

class DirectivesController < ApplicationController
  respond_to :html
  respond_to :xml
  respond_to :json, only: :index
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit new create update]
  before_action :set_directive, except: %i[index autocomplete]

  def index
    directives = Directive.search(params[:search])
    directives = directives.where(title: params[:title]) if params[:title].present?
    directives = directives.where(body: params[:body]) if params[:body].present?
    directives = directives.where(status: params[:status]) if params[:status].present?
    @directives = directives.order(sort_order(sort_column, sort_direction)).page(params[:page])
    @header = header(params)
  end

  def show
    @bproces_of_directive = Bproce.last&.bproces_of_directive(@directive.id) # процессы, документы которых ссылаются на директиву
    respond_with(@directive)
  end

  def autocomplete
    @directives = Directive.order(:number).where('number ilike ?', "%#{params[:term]}%")
    # render json: @directives, :only => [:id, :title, :number, :shortname, :approval]
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
    @directive = Directive.new(directive_params)
    flash[:notice] = 'Successfully created directive.' if @directive.save
    respond_with(@directive)
  end

  def update
    flash[:notice] = 'Successfully updated directive.' if @directive.update(directive_params)
    respond_with(@directive)
  end

  def destroy
    flash[:notice] = 'Successfully destroyed directive.' if @directive.destroy
    respond_with(@directive)
  end

  def document_create
    @directive = Directive.find(params[:id])
    @document_directive = @directive.document_directive.new
    render :document_create
  end

  private

  def directive_params
    params.require(:directive)
          .permit(:title, :number, :approval, :name, :note, :body, :annotation, :status, :action)
  end

  def sort_column
    params[:sort] || 'number'
  end

  def set_directive
    if params[:search].present? # это поиск
      directives = Directive.search(params[:search])
      @directives = directives.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @directive = params[:id].present? ? Directive.find(params[:id]) : Directive.new
    end
  end

  def header(params)
    header = 'Директивы '
    %i[title body status search].each do |key|
      next if params[key].blank?

      header += 'в статусе ' if key == :status
      header += 'поиск ' if key == :search
      header += "[#{params[key]}]"
    end
    header
  end
end
