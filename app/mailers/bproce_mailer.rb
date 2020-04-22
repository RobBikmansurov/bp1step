# frozen_string_literal: true

class BproceMailer < ApplicationMailer
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка об отстутствии ролей в процессе
  def process_without_roles(bproce, user)
    @bproce = bproce
    @user = user
    mail(to: user.email, subject: "BP1Step: не выделены роли в процессе ##{@bproce.id}")
  end
end
