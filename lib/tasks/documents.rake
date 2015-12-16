# encoding: utf-8
namespace :bp1step do

  desc 'Check statuses for documents'
  task :check_documents_status => :environment do  # проверить статус документов, выдалть оповещение для долго находящиихся на согласовании или в проекте
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_statuses_for_documents'
    document_count = 0
    document_count_s = 0
    document_count_p = 0
    document_count_e = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Document.where.not(status: "Утвержден").where.not(status: "НеДействует").each do |document| # документы в промежуточных статусах
      document_count += 1
      emails = u.email # DEBUG
      emails = document.owner.email.to_s if document.owner   # владелец документа
      case document.status
      when 'Согласование'
        if document.created_at < Date.current - 21  # даем три недели на согласование
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
      logger.info "      ##{document.id.to_s} \t#{emails} \tстатус: [#{document.status}] \tсоздан: #{document.created_at.strftime('%d.%m.%Y')}"
    end
    logger.info "      #{document_count} documents:  Approval-#{document_count_s}, Project-#{document_count_p}, Unknown-#{document_count_e}"
  end

end