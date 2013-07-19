# coding: utf-8
class DocumentMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def file_not_found_email(document, user)		# рассылка об отстутствии файла документа
    @doc = document
    @user = user
    mail(:to => user.email, :subject => "BP1Step: нет файла документа ##{@doc.id.to_s}")
  end
end
