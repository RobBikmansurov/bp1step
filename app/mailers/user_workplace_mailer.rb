# frozen_string_literal: true

class UserWorkplaceMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка о назначении сотрунику РМ
  def user_workplace_create(user_workplace, current_user)
    @user_workplace = user_workplace
    @workplace = user_workplace.workplace
    @user = user_workplace.user
    @current_user = current_user
    mail(to: @user.email, subject: "BP1Step: Ваше Рабочее место - #{@workplace.designation}")
  end

  # рассылка об удалении исполнителя
  def user_workplace_destroy(user_workplace, current_user)
    @user_workplace = user_workplace
    @workplace = user_workplace.workplace
    @user = user_workplace.user
    @current_user = current_user
    mail(to: @user.email, subject: "BP1Step: Рабочее место #{@workplace.designation}")
  end
end
