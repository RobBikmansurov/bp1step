class WorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @workplaces = Workplace.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    respond_with(@workplace = Workplace.find(params[:id]))
  end

  def new
    @workplace = Workplace.new
    respond_with(@workplace)
  end

  def edit
    @workplace = Workplace.find(params[:id])
    if flash[:bapp]
      @workplace = flash[:bapp]
    else
      @workplace = Workplace.find(params[:id])
      @bproce_workplace = BproceWorkplace.new(:workplace_id => @workplace.id)
    end
  end

  def create
    @workplace = Workplace.create(params[:workplace])
    flash[:notice] = "Successfully created workplace." if @workplace.save
    respond_with(@workplace)
  end

  def update
    @workplace = Workplace.find(params[:id])
    flash[:notice] = "Successfully updated workplace."  if @workplace.update_attributes(params[:workplace])
    respond_with(@workplace)
  end

  def destroy
    @workplace = Workplace.find(params[:id])
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

end
