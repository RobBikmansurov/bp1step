# frozen_string_literal: true

class BusinessRolesController < ApplicationController
  require 'net/smtp'
  respond_to :html
  respond_to :odt, :xml, :json, only: :index
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit new create update]
  before_action :business_role, except: %i[index print new]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @business_roles = BusinessRole.order(sort_column + ' ' + sort_direction)
    if params[:all].blank?
      @business_roles = @business_roles.search(params[:search]) if params[:search].present?
      @business_roles = @business_roles.order(sort_column + ' ' + sort_direction).page(params[:page])
      # @business_roles = BusinessRole.page(params[:page]).search(params[:search])
      # @business_roles = BusinessRole.paginate(:per_page => 10, :page => params[:page])
    end
    # @business_roles = @business_roles.find(:all, :include => :users)
    @business_roles = @business_roles.includes(:users)
    respond_to do |format|
      format.html
      format.odt { print }
    end
  end

  def new
    @business_role = BusinessRole.new
    if params[:bproce_id].present?
      @bproce = Bproce.find(params[:bproce_id])
      @business_role.bproce_id = @bproce.id
    end
    respond_with(@business_role)
  end

  def create
    @business_role = BusinessRole.new(business_role_params)
    if params[:business_role][:bproce_name].present?
      name = params[:business_role][:bproce_name]
      @bproce = Bproce.where(name: name).first
      @business_role.bproce_id = @bproce.id
    end
    flash[:notice] = 'Successfully created role.' if @business_role.save
    respond_with(@business_role)
  end

  def create_user
    @business_role = BusinessRole.find(params[:id])
    @user_business_role = UserBusinessRole.new(business_role_id: @business_role.id) # заготовка для исполнителя
    render :create_user
  end

  def update_user
    user_business_role = UserBusinessRole.new(user_business_role_params) if params[:user_business_role].present?
    if user_business_role
      if user_business_role.save
        flash[:notice] = "Новый исполнитель #{user_business_role.user_name} назначен"
        begin
          UserBusinessRoleMailer.user_create_role(user_business_role, current_user).deliver_now # оповестим нового исполнителя
        rescue Net::SMTPAuthenticationError,
               Net::SMTPServerBusy,
               Net::SMTPSyntaxError,
               Net::SMTPFatalError,
               Net::SMTPUnknownError => e
          logger.warn "Error - business_role.update_user: #{e}"
          flash[:alert] = "Error sending mail to #{user_business_role.user.email}"
        end
        @business_role = user_business_role.business_role
      end
    else
      flash[:alert] = 'Ошибка - ФИО Сотрудника не указано.'
    end
    respond_with(@business_role)
  end

  def show
    respond_with(@business_role)
  end

  def edit
    @user_business_role = UserBusinessRole.new(business_role_id: @business_role.id,
                                               date_from: Date.current.strftime('%d.%m.%Y'),
                                               date_to: Date.current.change(month: 12, day: 31).strftime('%d.%m.%Y'))
    respond_with(@business_role, @user_business_role)
  end

  def update
    @user_business_role = UserBusinessRole.new(business_role_id: @business_role.id)
    # оповестим исполнителей роли об изменениях
    begin
      BusinessRoleMailer.update_business_role(@business_role, current_user).deliver_now
      flash[:notice] = 'Successfully updated role.' if @business_role.update(business_role_params)
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.warn "Error - business_role.update: #{e}"
      flash[:alert] = 'Error sending mail to business role workers'
    end
    respond_with(@business_role)
  end

  def destroy
    bproce = @business_role.bproce_id # есть у роли процесс
    flash[:notice] = 'Successfully destroyed business_role.' if @business_role.destroy
    if bproce
      redirect_to(bproce_business_role_path(bproce)) # вернемся в роли процесса
    else
      respond_with(@business_role)
    end
  end

  def mail; end

  def mail_all
    begin
      BusinessRoleMailer.mail_all(@business_role, current_user, params[:mail_text]).deliver_now
      flash[:notice] = 'Mails have been sent successfully'
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.warn "Error - business_role.mail_all: #{e}"
      flash[:alert] = 'Errors when sending mail'
    end
    respond_with(@business_role)
  end

  private

  def business_role_params
    params.require(:business_role).permit(:name, :description, :bproce_id, :features)
  end

  def user_business_role_params
    params.require(:user_business_role).permit(:user_id, :user_name, :business_role_id, :note, :date_from, :date_to)
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def business_role
    if params[:search].present? # это поиск
      @business_roles = BusinessRole.search(params[:search])
                                    .order(sort_column + ' ' + sort_direction)
                                    .paginate(per_page: 10, page: params[:page])
                                    .find(:all, include: :users)
      render :index # покажем список найденных бизнес-ролей
    else
      @business_role = params[:id].present? ? BusinessRole.find(params[:id]) : BusinessRole.new
    end
  end

  def print
    report = ODFReport::Report.new('reports/broles.odt') do |r|
      nn = 0
      r.add_field 'REPORT_DATE', Date.current
      r.add_table('TABLE_01', @business_roles, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name)
        t.add_column(:bpname) do |br|
          br.bproce&.shortname.to_s
        end
        t.add_column(:description)
      end
      r.add_field 'USER_POSITION', current_user.position
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'business_roles.odt',
                               disposition: 'inline'
  end

  def record_not_found
    flash[:alert] = 'Неверный #id, Бизнес-роль не найдена.'
    redirect_to action: :index
  end
end
