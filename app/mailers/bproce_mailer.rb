# coding: utf-8
class BproceMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def process_without_roles(bproce, user)		# рассылка об отстутствии ролей в процессе
    @bproce = bproce
    @user = user
    mail(:to => user.email, :subject => "BP1Step: не выделены роли в процессе ##{@bproce.id.to_s}")
  end
end
