# frozen_string_literal: true

class RequirementsController < ApplicationController
  include Reports
  include Users

  respond_to :html, :json
  helper_method :sort_column, :sort_direction, :requiremnt_policy
  before_action :authenticate_user! # , only: %i[edit new create update check show]
  before_action :allowed_user!
  before_action :set_requirement, only: %i[show edit update destroy tasks_list tasks_report]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @title_requirements = 'Требования '
    if params[:status].present?
      @requirements = Requirement.status(params[:status]).includes(:user_requirement)
      @title_requirements += "в статусе [ #{REQUIREMENT_STATUS.key(params[:status].to_i)} ]"
    else
      @requirements = Requirement.search(params[:search]).unfinished.includes(:user_requirement)
      @title_requirements += 'не завершенные'
    end
    @requirements = @requirements.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
  end

  def show
    @tasks = Task.where('requirement_id = ?', @requirement.id)
    @tasks = if params[:sort].present?
               @tasks.order(sort_order(sort_column, sort_direction))
             else
               @tasks.order('status, duedate, id')
             end
  end

  def new
    @requirement = Requirement.new
    @requirement.letter_id = params[:letter_id] if params[:letter_id].present?
    @requirement.author_id = current_user.id if user_signed_in?
  end

  def edit
    @user_requirement = UserRequirement.new(requirement_id: @requirement.id)
  end

  def create
    @requirement = Requirement.new(requirement_params)
    if @requirement.save
      redirect_to @requirement, notice: 'Requirement was successfully created.'
    else
      render action: 'new'
    end
  end

  def create_task
    parent_requirement = Requirement.find(params[:id])
    redirect_to(new_task_url(requirement_id: parent_requirement.id)) && return
  end

  def create_user
    @requirement = Requirement.find(params[:id])
    @user_requirement = UserRequirement.new(requirement_id: @requirement.id) # заготовка для исполнителя
    render :create_user
  end

  def update
    status_was = @requirement.status # старые значения записи
    if @requirement.update(requirement_params)
      @requirement.status = 90 if params[:commit].present? && params[:commit].end_with?('Завершить')
      @requirement.update! status: @requirement.status unless @requirement.status == status_was
      if (@requirement.status >= 90) && status_was < 90 # стало завершено
        @requirement.result += time_and_current_user 'считает требование полностью исполненным'
        @requirement.update! result: @requirement.result.to_s
      end
      redirect_to @requirement, notice: 'Requirement was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def update_user
    user_requirement = UserRequirement.new(user_requirement_params) if params[:user_requirement].present?
    if user_requirement
      # проверим - нет такого исполнителя?
      user_requirement_clone = UserRequirement.where(requirement_id: user_requirement.requirement_id,
                                                     user_id: user_requirement.user_id).first
      if user_requirement_clone
        user_requirement_clone.status = user_requirement.status
        user_requirement = user_requirement_clone
      end
      if user_requirement.save
        flash[:notice] = "Исполнитель #{user_requirement.user_name} назначен"
        begin
          UserRequirementMailer.user_requirement_create(user_requirement, current_user).deliver_now # оповестим нового исполнителя
        rescue StandardError => e
          flash[:alert] = "Error sending mail to #{user_requirement.user.email}\n#{e}"
        end
        @requirement = user_requirement.requirement # requirement.find(@user_requirement.requirement_id)
        @requirement.update! status: 5 if @requirement.status < 1 # если есть ответственные - статус = Назначено
      end
    else
      flash[:alert] = 'Ошибка - ФИО Исполнителя не указано.'
    end
    respond_with(@requirement)
  end

  def destroy
    @requirement.destroy
    redirect_to requirements_url, notice: 'Requirement was successfully destroyed.'
  end

  def tasks_list
    @tasks = Task.where('requirement_id = ?', @requirement.id).order('duedate, status')
    tasks_list_report
  end

  def tasks_report
    @tasks = Task.where('requirement_id = ?', @requirement.id).order('duedate, status')
    tasks_report_report
  end

  private

  def set_requirement
    @requirement = Requirement.find(params[:id])
  end

  def requirement_params
    params.require(:requirement)
          .permit(:label, :date, :duedate, :source, :body, :status, :status_name, :result, :letter_id, :author_id, :author_name)
  end

  def user_requirement_params
    params.require(:user_requirement)
          .permit(:user_id, :requirement_id, :status, :user_name)
  end

  def sort_column
    params[:sort] || 'duedate'
  end

  def sort_direction
    params[:direction] || 'desc'
  end

  def record_not_found
    flash[:alert] = "Требование ##{params[:id]} не найдено"
    redirect_to action: :index
  end

  def tasks_list_report
    report = ODFReport::Report.new('reports/requirement_tasks_list.odt') do |r| # rubocop:disable Metrics/BlockLength
      nn = 0
      report_header r
      r.add_field 'REQUIREMENT_USERS', requirement_users

      r.add_table('TASKS', @tasks, header: true) do |t| # rubocop:disable Metrics/BlockLength
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:id)
        t.add_column(:name) do |task|
          "[#{task.name}]"
        end
        t.add_column(:date) do |task|
          "от #{task.created_at.strftime('%d.%m.%y')}"
        end
        t.add_column(:author, :author_name)
        t.add_column(:description) do |task|
          task.description.to_s
        end
        t.add_column(:duedate) do |task|
          days = task.duedate - Date.current
          task.duedate.strftime('%d.%m.%y').to_s + (days.negative? ? "  (+ #{(-days).to_i} дн.)" : '')
        end
        t.add_column(:status) do |task|
          TASK_STATUS.key(task.status)
        end
        t.add_column(:users) do |task| # исполнители задачи
          task_users_list task
        end
        t.add_column(:result)
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: "requirement#{@requirement.id}_tasks_list.odt",
                               disposition: 'inline'
  end

  def tasks_report_report
    report = ODFReport::Report.new('reports/requirement_tasks_report.odt') do |r| # rubocop:disable Metrics/BlockLength
      nn = 0
      report_header r
      r.add_field 'REQUIREMENT_USERS', requirement_users

      r.add_table('TASKS', @tasks, header: true) do |t| # rubocop:disable Metrics/BlockLength
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:id)
        t.add_column(:name) do |task|
          "[#{task.name}]"
        end
        t.add_column(:result) do |task|
          task.result.to_s
        end
        t.add_column(:date) do |task|
          "от #{task.created_at.strftime('%d.%m.%y')}"
        end
        t.add_column(:author, :author_name)
        t.add_column(:duedate) do |task|
          task.duedate&.strftime('%d.%m.%y')
        end
        t.add_column(:completiondate) do |task|
          task.completion_date&.strftime('%d.%m.%y')
        end
        t.add_column(:completionalert) do |task|
          if task.completion_date
            days = task.completion_date - task.duedate if task.duedate
            (days.positive? ? " (опоздание #{days.to_i} дн.)" : '')
          end
        end
        t.add_column(:status) do |task|
          TASK_STATUS.key(task.status)
        end
        t.add_column(:users) do |task| # исполнители задачи
          task_users_list task
        end
        t.add_column(:result)
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'requirement_tasks_report.odt',
                               disposition: 'inline'
  end

  def report_header(report)
    report.add_field 'REQUIREMENT_DATE', @requirement.date.strftime('%d.%m.%Y')
    report.add_field 'REQ_ID', @requirement.id
    report.add_field 'REQUIREMENT_LABEL', @requirement.label
    report.add_field 'REQUIREMENT_BODY', @requirement.body
    if @requirement.letter
      s = 'Основание: Вх.№  '
      s += "#{@requirement.letter.number} от #{@requirement.letter.date.strftime('%d.%m.%Y')}"
    else
      s = "Источник: #{@requirement.source}"
    end
    report.add_field 'REQUIREMENT_SOURCE', s
    report.add_field 'REQUIREMENT_DUEDATE', @requirement.duedate.strftime('%d.%m.%Y')
    report.add_field 'REQUIREMENT_AUTHOR', @requirement.author.displayname.to_s
  end

  def requirement_users(users = '')
    @requirement.user_requirement.find_each do |user_requirement|
      users += ', ' if users.present?
      users += user_requirement.user.displayname
      users += '-отв.' if user_requirement.status.positive?
    end
    users
  end

  def task_users_list(task, list = '')
    task.user_task.find_each do |user_task|
      list += ', ' if list.present?
      list += user_task.user.displayname
      list += '-отв.' if user_task.status&.positive?
    end
    list
  end

  def allowed_user!
    return if requirement_policy.allowed?(current_user)

    flash[:alert] = 'Нет прав для работы с Требованиями'
    redirect_to current_user
  end

  def requirement_policy
    @requirement_policy ||= RequirementPolicy.new
  end
end
