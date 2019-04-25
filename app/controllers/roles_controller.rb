# frozen_string_literal: true

class RolesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :set_role, only: :show

  def index
    roles = Role.search(params[:search])
    @roles = roles.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
  end

  def show; end

  private

  def role_params
    params.require(:role).permit(:name, :description, :user_id)
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def set_role
    @role = params[:id].present? ? Role.find(params[:id]) : Role.new
  end
end
