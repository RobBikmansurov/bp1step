class TasksController < ApplicationController
  respond_to :html, :json
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @title_tasks = 'Задачи '
    if params[:user].present?
      user = User.find(params[:user])
      @tasks = Task.joins(:user_task).where("user_tasks.user_id = ?", "#{params[:user]}")
      @title_tasks += "исполнителя [ #{user.displayname} ]"
      if params[:status].present?
        @tasks = @tasks.where('tasks.status = ?', params[:status])
        @title_tasks += "в статусе [ #{TASK_STATUS.key(params[:status].to_i)} ]"
      else
        @tasks = @tasks.where('tasks.status < 90', params[:status])
        @title_tasks += " не завершенные"
      end
    else
      if params[:status].present?
        @tasks = Task.where('tasks.status = ?', params[:status])
        @title_tasks += "в статусе [ #{TASK_STATUS.key(params[:status].to_i)} ]"
      else
        @tasks = Task.search(params[:search]).where('status < 90').includes(:user_task)
        @title_tasks += 'не завершенные'
      end
    end
    @tasks = @tasks.order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
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
      @requirement = Requirement.find(params[:requirement_id] )
      @task.requirement_id = @requirement.id if @requirement
    end
    if params[:letter_id].present?
      @letter= Letter.find(params[:letter_id] )
      @task.letter_id = @letter.id if @letter
    end
    @task.author_id = current_user.id
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def create_user
    @task = Task.find(params[:id])
    @user_task = UserTask.new(task_id: @task.id)    # заготовка для исполнителя
    render :create_user
  end

  def update
    status_was = @task.status
    if @task.update(task_params)
      @task.result += "\r\n" + Time.current.strftime("%d.%m.%Y %H:%M:%S") + ": #{current_user.displayname} - " + params[:task][:action] if params[:task][:action].present?
      @task.result += "\r\n" + Time.current.strftime("%d.%m.%Y %H:%M:%S") + ": #{current_user.displayname} считает задачу полностью исполненной" if @task.status >= 90 and status_was < 90 # стало завершено
      @task.update_column(:result, "#{@task.result}")
      redirect_to @task, notice: 'Задача изменена'
    else
      render :edit
    end
  end

  def update_user
    user_task = UserTask.new(params[:user_task]) if params[:user_task].present?
    if user_task
      user_task_clone = UserTask.where(task_id: user_task.task_id, user_id: user_task.user_id).first  # проверим - нет такого исполнителя?
      if user_task_clone
        user_task_clone.status = user_task.status
        user_task = user_task_clone
      end
      if user_task.save
        flash[:notice] = "Исполнитель #{user_task.user_name} назначен"
        begin
          UserTaskMailer.user_task_create(user_task, current_user).deliver_now    # оповестим нового исполнителя
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          flash[:alert] = "Error sending mail to #{user_task.user.email}"
        end
        @task = user_task.task   #task.find(@user_task.task_id)
        @task.update_column(:status, 5) if @task.status < 1 # если есть ответственные - статус = Назначено
      end
    else
      flash[:alert] = "Ошибка - ФИО Исполнителя не указано."
    end
    respond_with(@task)
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  def record_not_found
    flash[:alert] = "Неверный #id - нет такой задачи."
    redirect_to action: :index
  end


  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :duedate, :result, :status, :result, :letter_id, :requirement_id, :author_id, :completion_date, :status_name)
    end

    def sort_column
      params[:sort] || "id"   # вверху - самые новые задачи
    end

    def sort_direction
      params[:direction] || "desc"
    end

end
