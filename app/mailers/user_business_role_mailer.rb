# frozen_string_literal: true

class UserBusinessRoleMailer < ApplicationMailer
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка о назначении исполнителя на роль в процессе
  def user_create_role(user_business_role, current_user)
    @user_business_role = user_business_role
    @bproce = user_business_role.business_role.bproce
    @user = user_business_role.user
    @current_user = current_user
    mail(to: @user.email, subject: "BP1Step: Вы - исполнитель в процессе ##{@bproce.id}")
  end

  # рассылка об удалении исполнителя из роли в процессе
  def user_delete_role(user_business_role, current_user)
    @user_business_role = user_business_role
    @bproce = user_business_role.business_role.bproce
    @user = user_business_role.user
    @current_user = current_user
    mail(to: @user.email, subject: "BP1Step: удален исполнитель из процесса ##{@bproce.id}")
  end
end
