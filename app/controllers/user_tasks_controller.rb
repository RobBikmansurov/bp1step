# frozen_string_literal: true

class UserTasksController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[new create destroy]

  def show
    @user_task = UserTask.find(params[:id])
    redirect_to(Task_path(@user_task.Task_id)) && return
  end

  def new
    @user_task = UserTask.new(status: 0)
  end

  def create
    @user_task = UserTask.new(user_task_params)
    if @user_task.save
      flash[:notice] = 'Successfully created user_task.'
      begin
        UserTaskMailer.user_task_create(@user_task, current_user).deliver_now # оповестим нового исполнителя
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = "Error sending mail to #{@user_task.user.email}"
      end
      task = Task.find(@user_task.task_id)
      task.update_column(:status, 5) if task.status < 1 # если есть ответственные - статус = Назначено
    else
      flash[:alert] = 'Error create user_task'
    end
    respond_with(@user_task)
  end

  def destroy
    @user_task = UserTask.find(params[:id]) # нашли удаляемую связь
    @task = Task.find(@user_task.task_id) # запомнили письмо для этой удаляемой связи
    begin
      UserTaskMailer.user_task_destroy(@user_task, current_user).deliver_now # оповестим исполнителя
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_task.user.email}"
    end
    if @user_task.destroy # удалили связь
      @task.update_column(:status, 0) unless @task.user_task.first # если нет ответственных - статус = Новая
    end
    # respond_with(@task)  # вернулись в задачу
    respond_to do |format|
      format.html { respond_with(@task, notice: 'Удален исполнитель задачи.') }
      format.json { head :no_content }
      format.js   { render layout: false }
    end
  end

  private

  def user_task_params
    params.require(:user_task)
          .permit(:user_id, :task_id, :status, :user_name)
  end
end
