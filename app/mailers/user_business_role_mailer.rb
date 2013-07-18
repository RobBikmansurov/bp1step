# coding: utf-8
class UserBusinessRoleMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def user_create_role(user_business_role)		# рассылка о назначении исполнителя на роль в процессе
    @user_business_role = user_business_role
    @bproce = user_business_role.business_role.bproce
    @user = user_business_role.user
    mail(:to => @user.email, :subject => "BP1Step: добавлен исполнитель в процесс ##{@bproce.id.to_s}")
  end

  def user_delete_role(user_business_role)		# рассылка об удалении исполнителя из роли в процессе
    @user_business_role = user_business_role
    @bproce = user_business_role.business_role.bproce
    @user = user_business_role.user
    mail(:to => @user.email, :subject => "BP1Step: удален исполнитель в процессе  ##{@bproce.id.to_s}")
  end
end
