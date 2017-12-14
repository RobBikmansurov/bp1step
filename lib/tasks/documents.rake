# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
namespace :bp1step do
  desc 'Check statuses for documents'
  task check_documents_status: :environment do # проверить статус документов, выдалть оповещение для долго находящиихся на согласовании или в проекте
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_statuses_for_documents'
    document_count = 0
    document_count_s = 0
    document_count_p = 0
    document_count_e = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Document.where.not(status: 'Утвержден').where.not(status: 'НеДействует').each do |document| # документы в промежуточных статусах
      document_count += 1
      emails = u.email # DEBUG
      emails = document.owner.email.to_s if document.owner # владелец документа
      case document.status
      when 'Согласование'
        if document.created_at < Date.current - 21 # даем три недели на согласование
          document_count_s += 1
          DocumentMailer.check_documents_status(document, emails, 'завершите процедуру согласования или переведите в статус [Проект]').deliver_now
        end
      when 'Проект'
        document_count_p += 1
      else
        if document.dlevel < 4
          document_count_e += 1
          DocumentMailer.check_documents_status(document, emails, 'установите статус').deliver_now
        end
      end
      logger.info "      ##{document.id} \t#{emails} \tстатус: [#{document.status}] \tсоздан: #{document.created_at.strftime('%d.%m.%Y')}"
    end
    logger.info "      #{document_count} documents:  Approval-#{document_count_s}, Project-#{document_count_p}, Unknown-#{document_count_e}"
  end

  desc 'Check document_file for documents with level 1-3 '
  task check_document_files: :environment do # проверка наличия файла документа для документов уровня 1-3 (кроме 4 - Свидетельства)
    # TODO контролировать все уровни документов кроме 4
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_document_files'
    documents_count = 0
    documents_file_missing = 0
    files_missing = 0
    processes_missing = 0
    pdfs_missing = 0
    DEBUG = false
    default_user = User.find(97) # пользователь по умолчанию

    Document.where('dlevel = 4').each do |document| # все документы типа Свидетельств должны иметь процесс
      documents_count += 1
      next if document.bproce.any?
      mail_to = document.owner if document.owner_id.positive?
      mail_to = default_user if DEBUG || mail_to.blank?
      processes_missing += 1
      logger.info "process missing ##{document.id}: \t#{mail_to.email}"
      DocumentMailer.process_is_missing_email(document, mail_to).deliver # рассылка о необходимости указания процесса для документа
    end

    Document.where('dlevel < 4').where(status: 'Утвержден').each do |document| # все документы кроме Свидетельств
      documents_count += 1
      mail_to = document.owner if document.owner_id.positive?
      mail_to = default_user if DEBUG || mail_to.blank?

      unless document.bproce.any?
        processes_missing += 1
        logger.info "process missing ##{document.id}: \t#{mail_to.email}"
        DocumentMailer.process_is_missing_email(document, mail_to).deliver # рассылка о необходимости указания процесса для документа
      end

      if document.document_file_file_name
        if File.exist?(document.document_file.path) # есть исходный файл документа
          if File.size(document.document_file.path) == document.document_file_file_size
            unless File.exist?(document.pdf_path) # есть PDF для просмотра
              Paperclip.run('unoconv', "-f pdf '#{document.document_file.path}'")
              pdfs_missing += 1
            end
          else
            logger.info "file is corrupted ##{document.id}: #{document.document_file_file_size} <> #{File.size(document.document_file.path)} \t #{mail_to.email}"
            DocumentMailer.file_is_corrupted_email(document, mail_to).deliver # рассылка о необходимости новой загрузки файла документа
          end
        else
          files_missing += 1
          DocumentMailer.file_is_corrupted_email(document, mail_to).deliver # рассылка о необходимости новой загрузки файла документа
          logger.info "file is missing ##{document.id}: #{document.document_file_file_name} \t #{mail_to.email}"
        end
      else
        unless document.note.start_with?('ДСП') #  если это не ДСП - должен быть файл
          documents_file_missing += 1
          DocumentMailer.file_not_found_email(document, mail_to).deliver # рассылка об отсутствии файла документа
          logger.info "file name is missing ##{document.id}: #{document.name} \t #{mail_to.email}"
        end
      end
    end
    logger.info "All: #{documents_count} docs, #{documents_file_missing} file names missing, #{files_missing} files missing, #{pdfs_missing} pdfs missing, #{processes_missing} without processes"
  end
end

# rubocop:enable
