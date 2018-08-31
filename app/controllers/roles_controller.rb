# frozen_string_literal: true

class RolesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit update new create]
  before_action :set_role, except: :index

  def index
    roles = Role.search(params[:search])
    @roles = roles.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
  end

  def new
    respond_with(@role)
  end

  def create
    if params[:user_id].present? # добавить роль пользователю
      @usr = User.find(params[:user_id])
      role = Role.find(params[:role])
      UserRole.create(user_id: @usr.id, role_id: role.id) if role
      redirect_to edit_user_path(@usr), notice: 'Successfully created role for user.'
    else
      @role = Role.new(role_params)
      flash[:notice] = 'Successfully created role.' if @role.save
      respond_with(@role)
    end
  end

  def show
    respond_with(@role = Role.find(params[:id]))
  end

  def edit
    respond_with(@role)
  end

  def update
    flash[:notice] = 'Successfully updated role.' if @role.update(role_params)
    respond_with(@role)
  end

  def destroy
    if params[:user_id].present? # удалить роль пользователю
      @usr = User.find(params[:user_id])
      role = Role.find(params[:id])
      UserRole.where(user_id: @usr.id, role_id: role.id).first.destroy if role
      redirect_to edit_user_path(@usr), notice: 'Successfully deleted role for user.'
    else
      @role.destroy
      flash[:notice] = 'Successfully destroyed role.' if @role.save
      respond_with(@role)
    end
  end

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
