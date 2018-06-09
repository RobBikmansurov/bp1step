# frozen_string_literal: true

class UserTaskMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка о назначении исполнителя
  def user_task_create(user_task, current_user)
    @user_task = user_task
    @task = user_task.task
    @user = user_task.user
    @current_user = current_user
    mail(to: @user.email,
         subject: "BP1Step: Вы - #{user_task.status.positive? ? 'отв.' : ''}исполнитель Задачи ##{@task.id}")
  end

  # рассылка об удалении исполнителя
  def user_task_destroy(user_task, current_user)
    @user_task = user_task
    @task = user_task.task
    @user = user_task.user
    @current_user = current_user
    mail(to: @user.email,
         subject: "BP1Step: удален исполнитель Задачи ##{@task.id}")
  end
end
