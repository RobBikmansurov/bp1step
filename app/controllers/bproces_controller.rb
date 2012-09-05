class BprocesController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_bproce, :except => :index

  def list
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction)
  end
  def index
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    respond_with(@bproce)
  end

  def new
    respond_with(@bproce)
  end

  def edit
    @business_role = BusinessRole.new(:bproce_id => @bproce.id)
    @document = Document.new(:bproce_id => @bproce.id)
    #@user = User.find_or_initialize(@bproce.user_id)
  end

  def create
    @bproce = Bproce.new(params[:bproce])
    flash[:notice] = "Bproce was successfully created." if @bproce.save
    respond_with(@bproce)
  end

  def update
    if params[:business_role].present?
      @business_role = Role.new(params[:business_role])
      @business_role.save if !@business_role.nil?
    end
    if params[:document].present?
      @document = Document.new(params[:document])
      @document.save if !@document.nil?
    end
    flash[:notice] = "Successfully updated Bproce." if @bproce.update_attributes(params[:bproce])
    if !@bproce.save # there was an error!
      flash[:bproce] = @bproce
      redirect_to :action => :edit
    end
    redirect_to :action => :index  # пойдем сразу на список Процессов
  end

  def destroy
    @bproce.destroy
    respond_with(@bproce)
  end

private
  def sort_column
    params[:sort] || "lft"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_bproce
    @bproce = params[:id].present? ? Bproce.find(params[:id]) : Bproce.new
  end

end
