class TermsController < ApplicationController
  respond_to :html
  respond_to :pdf, :odf, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_term, :except => [:index, :print]


  def index
    if params[:all].present?
      @terms = Term.all
    else
      if params[:apptype].present?
        @terms = Term.searchtype(params[:apptype]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        @terms = Term.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      end
    end
    respond_to do |format|
      format.html
      format.json { render json: @terms }
      format.pdf { print }
    end
  end

  def show
    @term = Term.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @term }
    end
  end

  def new
    @term = Term.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @term }
    end
  end

  def edit
    @term = Term.find(params[:id])
  end

  def create
    @term = Term.new(params[:term])

    respond_to do |format|
      if @term.save
        format.html { redirect_to @term, notice: 'Term was successfully created.' }
        format.json { render json: @term, status: :created, location: @term }
      else
        format.html { render action: "new" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.json
  def update
    @term = Term.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        format.html { redirect_to @term, notice: 'Term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.json
  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to terms_url }
      format.json { head :no_content }
    end
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
  def get_term
    if params[:search].present? # это поиск
      @terms = Term.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @term = params[:id].present? ? Term.find(params[:id]) : Term.new
    end
  end

end
