# coding: utf-8
class UserTaskMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def user_task_create(user_task, current_user)		# рассылка о назначении исполнителя
    @user_task = user_task
    @task = user_task.task
    @user = user_task.user
    @current_user = current_user
    mail(:to => @user.email, :subject => "BP1Step: Вы - #{user_task.status and user_task.status > 0 ? 'отв.' : ''}исполнитель Задачи ##{@task.id}")
  end

  def user_task_destroy(user_task, current_user)		# рассылка об удалении исполнителя
    @user_task = user_task
    @task = user_task.task
    @user = user_task.user
    @current_user = current_user
    mail(:to => @user.email, :subject => "BP1Step: удален исполнитель Задачи ##{@task.id}")
  end
end
