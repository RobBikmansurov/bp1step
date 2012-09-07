class WorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_workplace, :except => :index
  #load_and_authorize_resource

  def index
    @workplaces = Workplace.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    respond_with(@workplace = Workplace.find(params[:id]))
  end

  def new
    @bproce_workplace = BproceWorkplace.new
    respond_with(@workplace)
  end

  def create
    @workplace = Workplace.create(params[:workplace])
    flash[:notice] = "Successfully created workplace." if @workplace.save
    respond_with(@workplace)
  end

  def edit
    @bproce_workplace = BproceWorkplace.new(:workplace_id => @workplace.id)
    respond_with(@bproce_workplace)
  end

  def update
    flash[:notice] = "Successfully updated workplace."  if @workplace.update_attributes(params[:workplace])
    if !@workplace.save # there was an error!
      flash[:workplace] = @workplace
      redirect_to :action => :edit
    else
      respond_with(@workplace)
    end
  end

  def destroy
    @workplace.destroy
    flash[:notice] = "Successfully destroyed workplace."  if @workplace.save
    respond_with(@workplace)
  end

private
  def sort_column
    params[:sort] || "designation"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  def get_workplace
    @workplace = params[:id].present? ? Workplace.find(params[:id]) : Workplace.new
  end
end
