# encoding: utf-8
namespace :bp1step do

  desc 'Check status and date for documents in developing process'
  task :check_statuses_for_documents => :environment do  # проверить наличие процесса для каждого документа
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_statuses_for_documents'
    document_count = 0
    wo_bproce_count = 0
    Document.all.each do |document| # все документы
      document_count += 1
      if document.bproce_documents.count < 1  # есть процесса?
        puts document.id, document.owner.displayname
        wo_bproce_count += 1
      end
    end
    logger.info "      #{wo_bproce_count} dcouments without processes from #{document_count} documents"
  end

end