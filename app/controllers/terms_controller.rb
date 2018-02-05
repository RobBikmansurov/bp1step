# frozen_string_literal: true

class TermsController < ApplicationController
  respond_to :html
  respond_to :xml, :json, only: %i[index show]
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit update new create]
  before_action :get_term, except: %i[index print]

  def index
    @terms = if params[:all].present?
               Term.all
             else
               @terms = if params[:apptype].present?
                          Term.searchtype(params[:apptype]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
                        else
                          Term.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
                        end
             end
    respond_to do |format|
      format.html
      format.json { render json: @terms }
      format.xml { render xml: @terms }
    end
  end

  def show
    @term = Term.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @term }
      format.xml { render xml: @term }
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
    @term = Term.new(term_params)

    respond_to do |format|
      if @term.save
        format.html { redirect_to @term, notice: 'Term was successfully created.' }
        format.json { render json: @term, status: :created, location: @term }
      else
        format.html { render action: 'new' }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @term = Term.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(term_params)
        format.html { redirect_to @term, notice: 'Term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to terms_url }
      format.json { head :no_content }
    end
  end

  private

  def term_params
    params.require(:term).permit(:name, :shortname, :description, :note)
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def get_term
    if params[:search].present? # это поиск
      @terms = Term.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @term = params[:id].present? ? Term.find(params[:id]) : Term.new
    end
  end
end
