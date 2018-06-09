# frozen_string_literal: true

class DocumentMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка об отсутствии файла документа
  def file_not_found_email(document, user)
    @doc = document
    @user = user
    mail(to: user.email, subject: "BP1Step: загрузить файл документа ##{@doc.id}")
  end

  # рассылка о необходимости новой загрузки файла документа
  def file_is_corrupted_email(document, user)
    @doc = document
    @user = user
    mail(to: user.email, subject: "BP1Step: обновите файл документа ##{@doc.id}")
  end

  # рассылка о необходимости указания процесса для документа
  def process_is_missing_email(document, user)
    @doc = document
    @user = user
    mail(to: user.email, subject: "BP1Step: укажите процесс документа ##{@doc.id}")
  end

  # контроль статуса документов
  def check_documents_status(document, emails, text)
    @document = document
    @text = text
    mail(to: emails, subject: "BP1Step: статус документа ##{@document.id}")
  end
end
