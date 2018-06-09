# frozen_string_literal: true

class BusinessRoleMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка всем исполнителям роли
  def mail_all(business_role, current_user, text)
    @business_role = business_role
    address = business_role.users.active.pluck(:email).join(', ')
    @bproce = business_role.bproce
    address += ", #{@bproce.user.email}" if @bproce.user.email # владелец проесса
    @text = text
    @current_user = current_user
    mail(to: address, subject: "BP1Step: рассылка исполнителям [#{@business_role.name}] в процессе ##{@bproce.id}")
  end

  # рассылка исполнителям об изменении роли в процессе
  def update_business_role(business_role, current_user)
    @business_role = business_role
    address = business_role.users.active.pluck(:email).join(', ')
    @bproce = business_role.bproce
    address += ", #{@bproce.user.email}" if @bproce.user.email # владелец проесса
    @current_user = current_user
    mail(to: address, subject: "BP1Step: изменилась роль [#{@business_role.name}] в процессе ##{@bproce.id}")
  end
end
