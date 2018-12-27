# frozen_string_literal: true

class TasksController < ApplicationController
  respond_to :html, :json
  before_action :set_task, only: %i[show edit update destroy report]
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user! # , only: %i[edit new create update check show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @title_tasks = 'Задачи '
    params.delete :status if params[:reset].present? && params[:reset] == params[:status]
    if params[:user].present?
      user = User.find(params[:user])
      tasks = Task.joins(:user_task).where('user_tasks.user_id = ?', params[:user].to_s)
      @title_tasks += "исполнителя [ #{user.displayname} ]"
      if params[:status].present?
        tasks = @tasks.status(params[:status])
        @title_tasks += "в статусе [ #{TASK_STATUS.key(params[:status].to_i)} ]"
      else
        tasks = @tasks.unfinished
        @title_tasks += ' не завершенные'
      end
    elsif params[:status].present?
      tasks = Task.search(params[:search]).status(params[:status]).includes(:user_task)
      @title_tasks += "в статусе [ #{TASK_STATUS.key(params[:status].to_i)} ]"
    else
      tasks = Task.search(params[:search]).unfinished.includes(:user_task)
      @title_tasks += 'не завершенные'
    end
    tasks = tasks.order(sort_order)
    @tasks = tasks.paginate(per_page: 10, page: params[:page])
  end

  def show
    @requirement = Requirement.find(@task.requirement_id) if @task.requirement_id
    @letter = Letter.find(@task.letter_id) if @task.letter_id
    respond_to do |format|
      format.html
      format.json { render json: @task }
    end
  end

  def new
    @task = Task.new(status: 0)
    if params[:requirement_id].present?
      @requirement = Requirement.find(params[:requirement_id])
      @task.requirement_id = @requirement.id if @requirement
    end
    if params[:letter_id].present?
      @letter = Letter.find(params[:letter_id])
      @task.letter_id = @letter.id if @letter
    end
    @task_status_enabled = TASK_STATUS.select { |_key, value| value < 5 } # Оставим только одно разрешенное состояние
    @task.status = 0
    @task.duedate = Time.current.days_since(10).strftime('%d.%m.%Y')
    @task.author_id = current_user.id
  end

  def edit
    @task_status_enabled = enabled_statuses(@task, current_user.id) # автор и отв. могут переводить в любое состояние
  end

  def check
    @tasks = Task.where('status < 90 and duedate <= ?', Date.current + 1).order(:duedate)
    check_report
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      @task_status_enabled = TASK_STATUS.select { |_key, value| value < 5 } # Оставим только одно разрешенное состояние
      render :new
    end
  end

  def create_user
    @task = Task.find(params[:id])
    @user_task = UserTask.new(task_id: @task.id) # заготовка для исполнителя
    @user_task_status_boolean = false
    render :create_user
  end

  def update
    status_was = @task.status # старые значения записи
    duedate_was = @task.duedate
    if @task.update(task_params)
      @task.result += "\r\n" + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ": #{current_user.displayname} изменил срок исполнения (с #{duedate_was.strftime('%d.%m.%Y')} на #{@task.duedate.strftime('%d.%m.%Y')})" unless @task.duedate == duedate_was
      @task.result += "\r\n#{Time.current.strftime('%d.%m.%Y %H:%M:%S')}: #{current_user.displayname} - #{params[:task][:action]}" if params[:task][:action].present?
      @task.result += "\r\n" + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ": #{current_user.displayname} считает задачу полностью исполненной" if (@task.status >= 90) && status_was < 90 # стало завершено
      @task.update_column(:result, @task.result.to_s)
      redirect_to @task, notice: 'Информация по Задаче сохранена'
    else
      @task_status_enabled = enabled_statuses(@task, current_user.id) # автор и отв. могут переводить в любое состояние
      render :edit
    end
  end

  def update_user
    user_task = UserTask.new(user_task_params) if params[:user_task].present?
    if user_task
      @task = user_task.task
      if user_task.user_id
        user_task_clone = UserTask.where(task_id: user_task.task_id, user_id: user_task.user_id).first # проверим - нет такого исполнителя?
        if user_task_clone
          user_task_clone.status = user_task.status
          user_task = user_task_clone
        end
        user_task.status = params[:user_task][:status_boolean] if params[:user_task][:status_boolean].present?
        if user_task.save
          flash[:notice] = "Исполнитель #{user_task.user_name} назначен"
          begin
            UserTaskMailer.user_task_create(user_task, current_user).deliver_now # оповестим нового исполнителя
          rescue Net::SMTPAuthenticationError,
                 Net::SMTPServerBusy,
                 Net::SMTPSyntaxError,
                 Net::SMTPFatalError,
                 Net::SMTPUnknownError => e
            flash[:alert] = "Error sending mail to #{user_task.user.email}"
          end
          @task = user_task.task # task.find(@user_task.task_id)
          @task.update_column(:status, 5) if @task.status < 1 # если есть ответственные - статус = Назначено
        end
      else
        flash[:alert] = "Ошибка - исполнитель [#{params[:user_task][:user_name]}] не найден"
      end
    else
      flash[:alert] = 'Ошибка - ФИО Исполнителя не указано.'
    end
    respond_with(@task)
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  def record_not_found
    flash[:alert] = 'Неверный #id - нет такой задачи.'
    redirect_to action: :index
  end

  def report
    task_report
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :duedate, :result, :status,
                                 :letter_id, :requirement_id, :author_id, :completion_date, :status_name)
  end

  def user_task_params
    params.require(:user_task)
          .permit(:user_id, :task_id, :status, :user_name)
  end

  def sort_column
    params[:sort] || 'id' # вверху - самые новые задачи
  end

  def enabled_statuses(task, current_user_id)
    if (current_user_id == task.author.id) || task.user_task.where(status: 1).pluck(:user_id).include?(current_user_id)
      TASK_STATUS.select { |_key, value| value > 5 } # автору и отв. могут переводить в любое состояние
    else
      task_status_enabled = TASK_STATUS.select { |_key, value| value.positive? }
      task_status_enabled.select { |_key, value| value < 90 } if task.status < 90
    end
  end

  def task_report
    report = ODFReport::Report.new('reports/task_report.odt') do |r|
      nn = 0
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      r.add_field 'TASK_DATE', @task.created_at.strftime('%d.%m.%Y')
      r.add_field 'TASK_ID', @task.id
      r.add_field 'NAME', @task.name
      r.add_field 'DESCRIPTION', @task.description
      s = "Вх.№ #{@task.letter.number} от #{@task.letter.date.strftime('%d.%m.%Y')}" if @task.letter
      s = "Требование ##{@task.requirement.id} от #{@task.requirement.date.strftime('%d.%m.%Y')} [#{@task.requirement.label}]" if @task.requirement
      r.add_field 'SOURCE', s
      r.add_field 'DUEDATE', @task.duedate.strftime('%d.%m.%Y')
      r.add_field 'AUTHOR', @task.author.displayname.to_s
      s = ''
      @task.user_task.find_each do |user_task|
        s += ', ' if s.present?
        s += user_task.user.displayname
        s += '-отв.' if user_task.status&.positive?
      end
      r.add_field 'TASK_USERS', s.to_s
      r.add_field 'RESULT', @task.result.presence || 'Не исполнено!'
      s = ' '
      a = ' '
      days = 0
      if @task.completion_date
        s = @task.completion_date.strftime('%d.%m.%Y').to_s # %H:%M:%S')}"
        days = @task.completion_date - @task.duedate if @task.duedate
        a = " (с опозданием в #{days.to_i} дн.)" if days.positive?
      else
        days = Date.current - @task.duedate if @task.duedate
        a = " (опоздание уже #{days.to_i} дн.)" if days.positive?
      end
      r.add_field 'COMPLETIONALERT', a.to_s
      r.add_field 'COMPLETIONDATE', s.to_s
      r.add_field 'STATUS', TASK_STATUS.key(@task.status)

      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate,
              type: 'application/msword',
              filename: "task-#{@task.id}-#{Date.current.strftime('%Y%m%d')}.odt",
              disposition: 'inline'
  end

  def check_report #  Отчет "Контроль исполнения"
    report = ODFReport::Report.new('reports/tasks_check.odt') do |r|
      nn = 0
      r.add_field 'REPORT_PERIOD', Date.current.strftime('%d.%m.%Y')
      r.add_field 'WEEK_NUMBER', @week_number
      r.add_table('TASKS', @tasks, header: true) do |t|
        t.add_column(:nn) do |_r1| # порядковый номер строки таблицы
          nn += 1
        end
        t.add_column(:id)
        t.add_column(:name)
        t.add_column(:description)
        t.add_column(:author, :author_name)
        t.add_column(:source) do |task|
          source = ''
          source += "Письмо #{task.letter_id}" if task.letter_id
          source += "Требование ##{task.requirement_id}" if task.requirement_id
          source
        end
        t.add_column(:duedate) do |task|
          task.duedate.strftime('%d.%m.%y').to_s
        end
        t.add_column(:completiondate) do |task|
          task.completion_date&.strftime('%d.%m.%y').to_s
        end
        t.add_column(:completionalert) do |task|
          if task.completion_date
            days = task.completion_date - task.duedate if task.duedate
            (days.positive? ? " (опоздание #{days.to_i} дн.)" : '')
          else
            days = task.duedate - Date.current
            (days.negative? ? " (уже #{(-days).to_i} дн.)" : '')
          end
        end
        t.add_column(:status) do |task|
          TASK_STATUS.key(task.status)
        end
        t.add_column(:users) do |task| # исполнители
          s = ''
          task.user_task.find_each do |user_task|
            s += ', ' if s.present?
            s += user_task.user.displayname
            s += '-отв.' if user_task.status&.positive?
          end
          s
        end
        t.add_column(:result) do |task|
          task.result.presence || 'Не исполнено!'
        end
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "tasks-check-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end
end
