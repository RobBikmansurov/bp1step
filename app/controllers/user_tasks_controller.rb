class UserTasksController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:new, :create, :destroy]
  
  def show
    @user_task = UserTask.find(params[:id])
    redirect_to Task_path(@user_task.Task_id) and return
  end

  def new
    @user_task = UserTask.new(status: 0)
  end

  def create
    @user_task = UserTask.new(params[:user_task])
    if @user_task.save
      flash[:notice] = "Successfully created user_task."
      begin
        UserTaskMailer.user_task_create(@user_task, current_user).deliver_now    # оповестим нового исполнителя
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = "Error sending mail to #{@user_task.user.email}"
      end
      Task = Task.find(@user_task.Task_id)
      Task.update_column(:status, 5) if Task.status < 1 # если есть ответственные - статус = Назначено
    else
      flash[:alert] = "Error create user_task"
    end
    respond_with(@user_task)
  end

  def destroy
    @user_task = UserTask.find(params[:id])   # нашли удаляемую связь
    @Task = Task.find(@user_task.Task_id) # запомнили письмо для этой удаляемой связи
    begin
      UserTaskMailer.user_task_destroy(@user_task, current_user).deliver_now    # оповестим исполнителя
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_task.user.email}"
    end
    if @user_task.destroy   # удалили связь
      @Task.update_column(:status, 0) if !@Task.user_task.first # если нет ответственных - статус = Новое
    end
    respond_with(@Task)  # вернулись в письмо
  end

end
