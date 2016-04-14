class RequirementsController < ApplicationController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction
  before_action :set_requirement, only: [:show, :edit, :update, :destroy, :tasks_list, :tasks_report]
  before_filter :authenticate_user!, only: [:edit, :new, :create, :update, :check, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @title_requirements = 'Требования '
    if params[:status].present?
      @requirements = Requirement.where('status = ?', params[:status]).includes(:user_requirement)
      @title_requirements += "в статусе [ #{REQUIREMENT_STATUS.key(params[:status].to_i)} ]"
    else
      @requirements = Requirement.search(params[:search]).where('status < 90').includes(:user_requirement)
      @title_requirements += 'не завершенные'
    end
    @requirements = @requirements.order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    if params[:sort].present?
      @tasks = Task.where('requirement_id = ?', @requirement.id).order(sort_column + ' ' + sort_direction)
    else
      @tasks = Task.where('requirement_id = ?', @requirement.id).order('status, duedate, id')
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
    redirect_to proc { new_task_url(requirement_id: parent_requirement.id) } and return
  end

  def create_user
    @requirement = Requirement.find(params[:id])
    @user_requirement = UserRequirement.new(requirement_id: @requirement.id)    # заготовка для исполнителя
    render :create_user
  end

  def update
    if @requirement.update(requirement_params)
      redirect_to @requirement, notice: 'Requirement was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def update_user
    user_requirement = UserRequirement.new(params[:user_requirement]) if params[:user_requirement].present?
    if user_requirement
      user_requirement_clone = UserRequirement.where(requirement_id: user_requirement.requirement_id, user_id: user_requirement.user_id).first  # проверим - нет такого исполнителя?
      if user_requirement_clone
        user_requirement_clone.status = user_requirement.status
        user_requirement = user_requirement_clone
      end
      if user_requirement.save
        flash[:notice] = "Исполнитель #{user_requirement.user_name} назначен"
        begin
          UserRequirementMailer.user_requirement_create(user_requirement, current_user).deliver_now    # оповестим нового исполнителя
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          flash[:alert] = "Error sending mail to #{user_requirement.user.email}"
        end
        @requirement = user_requirement.requirement   #requirement.find(@user_requirement.requirement_id)
        @requirement.update_column(:status, 5) if @requirement.status < 1 # если есть ответственные - статус = Назначено
      end
    else
      flash[:alert] = "Ошибка - ФИО Исполнителя не указано."
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
      params.require(:requirement).permit(:label, :date, :duedate, :source, :body, :status, :status_name, :result, :letter_id, :author_id, :author_name)
    end
    def sort_column
      params[:sort] || "duedate"
    end

    def sort_direction
      params[:direction] || "desc"
    end

    def record_not_found
      flash[:alert] = "Требование ##{params[:id]} не найдено"
      redirect_to action: :index
    end

    def tasks_list_report
      report = ODFReport::Report.new("reports/requirement_tasks_list.odt") do |r|
        nn = 0
        r.add_field "REPORT_DATE", Date.current.strftime('%d.%m.%Y')
        r.add_field "REQUIREMENT_DATE", @requirement.date.strftime('%d.%m.%Y')
        r.add_field "REQ_ID", @requirement.id
        r.add_field "REQUIREMENT_LABEL", @requirement.label
        r.add_field "REQUIREMENT_BODY", @requirement.body
        if @requirement.letter
          s = "Основание: Вх.№  "
          s += "#{@requirement.letter.number} от #{@requirement.letter.date.strftime('%d.%m.%Y')}"
        else
          s = "Источник: #{@requirement.source}"
        end
        r.add_field "REQUIREMENT_SOURCE", s
        r.add_field "REQUIREMENT_DUEDATE", @requirement.duedate.strftime('%d.%m.%Y') if @requirement.duedate
        r.add_field "REQUIREMENT_AUTHOR", "#{@requirement.author.displayname}"
        s = ''
        @requirement.user_requirement.each do |user_requirement|
          s += ", " if !s.blank?
          s += user_requirement.user.displayname
          s += '-отв.' if user_requirement.status and user_requirement.status > 0
        end
        r.add_field "REQUIREMENT_USERS", s

        r.add_table("TASKS", @tasks, :header=>true) do |t|
          t.add_column(:nn) do |ca|
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
            "#{task.description}"
          end
          #t.add_column(:source)
          t.add_column(:duedate) do |task|
            days = task.duedate - Date.current
            "#{task.duedate.strftime('%d.%m.%y')}" + (days < 0 ? "  (+ #{(-days).to_i} дн.)" : "")
          end
          t.add_column(:status) do |task|
            TASK_STATUS.key(task.status)
          end
          t.add_column(:users) do |task|  # исполнители задачи
            s = ''
            task.user_task.each do |user_task|
              s += ", " if !s.blank?
              s += user_task.user.displayname
              s += '-отв.' if user_task.status and user_task.status > 0
            end
            "#{s}"
          end
          t.add_column(:result)
        end
        r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
        r.add_field "USER_NAME", current_user.displayname
      end
      send_data report.generate, type: 'application/msword',
        :filename => "requirement_tasks_list.odt",
        :disposition => 'inline'    
    end

    def tasks_report_report
      report = ODFReport::Report.new("reports/requirement_tasks_report.odt") do |r|
        nn = 0
        r.add_field "REPORT_DATE", Date.current.strftime('%d.%m.%Y')
        r.add_field "REQUIREMENT_DATE", @requirement.date.strftime('%d.%m.%Y')
        r.add_field "REQ_ID", @requirement.id
        r.add_field "REQUIREMENT_LABEL", @requirement.label
        r.add_field "REQUIREMENT_BODY", @requirement.body
        if @requirement.letter
          s = "Основание: Вх.№  "
          s += "#{@requirement.letter.number} от #{@requirement.letter.date.strftime('%d.%m.%Y')}"
        else
          s = "Источник: #{@requirement.source}"
        end
        r.add_field "REQUIREMENT_SOURCE", s
        r.add_field "REQUIREMENT_DUEDATE", @requirement.duedate.strftime('%d.%m.%Y')
        r.add_field "REQUIREMENT_AUTHOR", "#{@requirement.author.displayname}"
        s = ''
        @requirement.user_requirement.each do |user_requirement|
          s += ", " if !s.blank?
          s += user_requirement.user.displayname
          s += '-отв.' if user_requirement.status and user_requirement.status > 0
        end
        r.add_field "REQUIREMENT_USERS", s

        r.add_table("TASKS", @tasks, :header=>true) do |t|
          t.add_column(:nn) do |ca|
            nn += 1
            "#{nn}."
          end
          t.add_column(:id)
          t.add_column(:name) do |task|
            "[#{task.name}]"
          end
          t.add_column(:result) do |task|
            "#{task.result}"
          end
          t.add_column(:date) do |task|
            "от #{task.created_at.strftime('%d.%m.%y')}"
          end
          t.add_column(:author, :author_name)
          #t.add_column(:source)
          t.add_column(:duedate) do |task|
            days = task.duedate - Date.current
            "#{task.duedate.strftime('%d.%m.%y')}" # + (days < 0 ? " (+ #{(-days).to_i} дн.)" : "")
          end
          t.add_column(:completiondate) do |task|
            "#{task.completion_date.strftime('%d.%m.%y')}" if task.completion_date
          end
          t.add_column(:completionalert) do |task|
            if task.completion_date
              days = task.completion_date - task.duedate if task.duedate
              (days > 0 ? " (опоздание #{(days).to_i} дн.)" : "")
            end
          end
          t.add_column(:status) do |task|
            TASK_STATUS.key(task.status)
          end
          t.add_column(:users) do |task|  # исполнители задачи
            s = ''
            task.user_task.each do |user_task|
              s += ", " if !s.blank?
              s += user_task.user.displayname
              s += '-отв.' if user_task.status and user_task.status > 0
            end
            "#{s}"
          end
          t.add_column(:result)
        end
        r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
        r.add_field "USER_NAME", current_user.displayname
      end
      send_data report.generate, type: 'application/msword',
        :filename => "requirement_tasks_report.odt",
        :disposition => 'inline'    
    end

end
