# coding: utf-8
# frozen_string_literal: true
class DocumentMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  def file_not_found_email(document, user)	# рассылка об отсутствии файла документа
    @doc = document
    @user = user
    mail(to: user.email, subject: "BP1Step: загрузить файл документа ##{@doc.id}")
  end

  def file_is_corrupted_email(document, user)	# рассылка о необходимости новой загрузки файла документа
    @doc = document
    @user = user
    mail(to: user.email, subject: "BP1Step: обновите файл документа ##{@doc.id}")
  end

  def process_is_missing_email(document, user)	# рассылка о необходимости указания процесса для документа
    @doc = document
    @user = user
    mail(to: user.email, subject: "BP1Step: укажите процесс документа ##{@doc.id}")
  end

  def check_documents_status(document, emails, text) # контроль статуса документов
    @document = document
    @text = text
    mail(to: emails, subject: "BP1Step: статус документа ##{@document.id}")
  end
end
