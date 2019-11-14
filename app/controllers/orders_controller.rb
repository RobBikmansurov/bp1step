# frozen_string_literal: true

class OrdersController < ApplicationController
  include Users

  before_action :authenticate_user!, except: %i[create_from_file]
  before_action :set_order, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create_from_file
    filename = params[:file]
    redirect_to orders_url, notice: 'parameter is missing.' unless filename.present?
    path_from_portal = Rails.root.join(Rails.configuration.x.dms.path_to_h_tmp, filename)
    redirect_to orders_url, notice: "#{filename} not exists." unless File.file? path_from_portal
    @order = create_order_from(path_from_portal)
    return false unless @order.save

    add_executors @order
    redirect_to @order, notice: 'Order was successfully created.'
  end

  def index
    @orders = Order.order(sort_order(sort_column, sort_direction))
  end

  def show; end

  def update
    command = params[:commit]
    action = params[:order][:action]
    approve(@order, action) if command == 'Согласовать'
    comment(@order, action) if command == 'Комментировать'
    complete(@order, action) if command == 'Подтвердить исполнение'
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :show
    end
  end

  def destroy
    @order.destroy
  end

  def sort_column
    params[:sort] || 'created_at'
  end

  def sort_direction
    params[:direction] || 'desc'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:type, :codpred, :author_id, :contract_number, :contract_date,
                                  :date, :due_date, :completed_at, :status, :result)
  end

  def create_order_from(file_path)
    json_file = File.read(file_path, encoding: 'windows-1251')
    json = JSON.parse json_file
    order = Order.new order_type: json['type'], codpred: json['codpred'], contract_number: json['dog_number'],
                      client_name: json['name'],
                      contract_date: json['dog_date'], status: 'Новое'
    order.author_id = order_author json['author']
    order
  end

  def order_author(author)
    fio, im, ot = author.split
    author = User.where('firstname=? and lastname=? and middlename=?', im, fio, ot).first
    author&.id
  end

  def add_executors(order)
    process = Bproce.find(Rails.configuration.x.dms.process_ko)
    return unless process

    business_role_id = BusinessRole.where(bproce_id: process.id, name: 'Исполнитель').pluck :id
    UserBusinessRole.where(business_role_id: business_role_id).each do |user|
      UserOrder.create(user_id: user.user_id, order_id: order.id)
    end
  end

  def record_not_found
    flash[:alert] = 'Неверный #id - нет такого распоряжения.'
    redirect_to action: :index
  end

  def approve(order, action)
    result = order.result
    result += time_and_current_user action
    result += time_and_current_user 'согласовал исполнение'
    order.update! status: 'Согласовано'
    params[:order][:result] = result
  end

  def comment(order, action)
    result = order.result
    result += time_and_current_user action
    params[:order][:result] = result
  end

  def complete(order, action)
    result = order.result
    result += time_and_current_user action
    result += time_and_current_user 'завершил исполнение'
    order.update! status: 'Исполнено'
    params[:order][:result] = result
  end
end
