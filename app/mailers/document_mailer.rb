# coding: utf-8
class DocumentMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def file_not_found_email(document, user)		# рассылка об отсутствии файла документа
    @doc = document
    @user = user
    mail(:to => user.email, :subject => "BP1Step: загрузить файл документа ##{@doc.id.to_s}")
  end

  def file_is_corrupted_email(document, user)		# рассылка о необходимости новой загрузки файла документа
    @doc = document
    @user = user
    mail(:to => user.email, :subject => "BP1Step: обновите файл документа ##{@doc.id.to_s}")
  end

  def process_is_missing_email(document, user)		# рассылка о необходимости указания процесса для документа
    @doc = document
    @user = user
    mail(:to => user.email, :subject => "BP1Step: укажите процесс документа ##{@doc.id.to_s}")
  end

end
