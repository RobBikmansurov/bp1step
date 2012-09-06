class BusinessRolesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_business_role, :except => :index

  def index
    @business_roles = BusinessRole.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    respond_with(@business_role)
  end

  def create
    @business_role = BusinessRole.new(params[:business_role])
    flash[:notice] = "Successfully created role." if @business_role.save
    respond_with(@business_role)
  end

  def show
    respond_with(@business_role = BusinessRole.find(params[:id]))
  end

  def edit
    @user_business_role = UserBusinessRole.new(:business_role_id => @business_role.id)
    respond_with(@business_role)
  end

  def update
    flash[:notice] = "Successfully updated role." if @business_role.update_attributes(params[:business_role])
    respond_with(@business_role)
  end

  def destroy
    @business_role.destroy
    flash[:notice] = "Successfully destroyed business_role." if @business_role.save
    respond_with(@business_role)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
  def get_business_role
    @business_role = params[:id].present? ? BusinessRole.find(params[:id]) : BusinessRole.new
  end

end
