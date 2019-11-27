# frozen_string_literal: true

class OrdersController < ApplicationController
  include Users

  before_action :authenticate_user!, except: %i[create_from_file]
  before_action :set_order, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create_from_file
    filename = params[:file]
    redirect_to orders_url, notice: 'parameter is missing.' unless filename.present?
    path_to_h_tmp = Rails.configuration.x.dms.path_to_h_tmp
    path_from_file_meta = Rails.root.join(path_to_h_tmp, filename)
    redirect_to orders_url, notice: "#{filename} not exists." unless File.file? path_from_file_meta
    @order = create_order_from(path_from_file_meta)
    flash[:alert] = @order.errors.messages
    redirect_to(orders_url) && return unless @order.valid?
    flash[:alert] = ''
    @order.save

    add_executors @order
    filename['json'] = 'pdf' # replace extension
    @order.attachment.attach(io: File.open(Rails.root.join(path_to_h_tmp, filename)),
                             filename: filename,
                             content_type: 'application/pdf')
    begin
      File.delete Rails.root.join(path_to_h_tmp, filename)
    rescue StandardError => e
      logger.error "Error file delete: #{e}"
    end
    redirect_to @order, notice: 'Order was successfully created.'
  end

  def index
    orders = Order.unfinished #.filter(filtering_params(params))
    @orders = orders.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
  end

  def show
    ActiveStorage::Current.host = request.base_url
  end

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
    redirect_to(orders_url) && return unless @order.status == 'Новое'
    order_destroyed = "##{@order.id} #{@order.order_type}"
    @order.attachment.purge if @order.attachment.attached?
    flash[:notice] = "#{order_destroyed} удалено" if @order.destroy
    redirect_to orders_url
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
    params.require(:order).permit(:type, :codpred, :author_id, :manager_id, :executor_id, :contract_number, :contract_date,
                                  :date, :due_date, :completed_at, :status, :result, :attachment)
  end

  def create_order_from(file_path)
    json_file = File.read(file_path, encoding: 'windows-1251')
    json = JSON.parse json_file
    order = Order.new order_type: json['type'], codpred: json['codpred'], contract_number: json['dog_number'],
                      client_name: json['name'],
                      contract_date: json['dog_date'], status: 'Новое'
    author_id = order_author(json['author'])
    logger.error "Error! Wrong author name: #{json['author']}" if author_id.blank?
    order.author_id = author_id
    begin
      File.delete file_path
    rescue StandardError => e
      logger.error "Error file delete: #{e}"
    end
    order
  end

  def order_author(author_a)
    fio, im, ot = author_a.split
    author = User.where('firstname=? and lastname=? and middlename=?', im, fio, ot).first
    return nil if author.blank?

    author.id
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
    result = order.result || ''
    result += time_and_current_user action unless action.blank?
    result += time_and_current_user 'согласовал исполнение'
    params[:order][:status] = 'Согласовано'
    params[:order][:manager_id] = current_user.id
    params[:order][:result] = result
  end

  def comment(order, action)
    result = order.result || ''
    result += time_and_current_user action
    params[:order][:result] = result
  end

  def complete(order, action)
    result = order.result || ''
    result += time_and_current_user action unless action.blank?
    result += time_and_current_user 'завершил исполнение'
    params[:order][:status] = 'Исполнено'
    params[:order][:executor_id] = current_user.id
    params[:order][:result] = result
  end

  def filtering_params(params)
    params.slice(:status, :codpred, :unfinished)
  end
end
