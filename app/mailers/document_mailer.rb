# coding: utf-8
class DocumentMailer < ActionMailer::Base
  default from: "robb@bankperm.ru"

  def file_not_found_email(document, user)		# рассылка об отстутствии файла документа
    @doc = document
    @user = user
    mail(:to => user.email, :subject => "BP1Step: отсутствует файл документа")
  end
end
