# coding: utf-8
class BusinessRoleMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def update_business_role(business_role, current_user)		# рассылка исполнителям об изменении роли в процессе
    @business_role = business_role
    @bproce = business_role.bproce
    address = @bproce.user.email if @bproce.user.email  # владелец проесса
    @business_role.users.each do | user |
      if !user.email.empty?
        address.concat(', ' + user.email.to_s)
      end
    end
    @current_user = current_user
    mail(:to => address, :subject => "BP1Step: изменилась роль [#{@business_role.name.to_s}] в процессе ##{@bproce.id.to_s}")
  end

end