# frozen_string_literal: true
class BusinessRoleMailer < ActionMailer::Base

  default from: 'BP1Step <bp1step@bankperm.ru>'

  # rubocop: disable Metrics/AbcSize
  def update_business_role(business_role, current_user)	# рассылка исполнителям об изменении роли в процессе
    @business_role = business_role
    @bproce = business_role.bproce
    address = @bproce.user.email if @bproce.user.email # владелец проесса
    @business_role.users.each do |user|
      address.concat(', ' + user.email.to_s) unless user.email.empty?
    end
    @current_user = current_user
    mail(to: address, subject: "BP1Step: изменилась роль [#{@business_role.name}] в процессе ##{@bproce.id}")
  end
end
