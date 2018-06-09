# frozen_string_literal: true

class TaskMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка исполнителям о просроченных письмах
  def check_overdue_tasks(task, emails)
    @task = task
    mail(to: emails, subject: "BP1Step: не исполнена Задача #{@task.id}")
  end

  # рассылка исполнителям о наступлении срока исполнения письма
  def soon_deadline_tasks(task, emails, days, users)
    @task = task
    @users = users
    @days = days.to_i
    mail(to: emails, subject: "BP1Step: #{@days} дн. на Задачу #{@task.id}")
  end
end
