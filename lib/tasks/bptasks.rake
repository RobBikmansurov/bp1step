# frozen_string_literal: true

# утилиты для поддержки работы BP1Step
# rubocop:disable Metrics/LineLength
# rubocop:disable Lint/UselessAssignment
namespace :bp1step do
  desc 'Check document files in eplace location'
  task check_document_files_eplace: :environment do # проверка наличия файлов документов в каталоге
    # TODO добавить конфиги для константы "files"

    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_document_files'

    nn = 1
    nf = 0
    u = User.find(97)
    Document.all.each do |d|
      fname = d.eplace
      unless fname.nil? # если указано имя файла документа
        if fname.size > 20
          fname = 'files' + d.file_name # добавим путь к файлам
          if File.exist?(fname)
          else
            nf += 1
            unless d.owner_id.nil?
              # u = User.find(d.owner_id)
            end
            logger.info "##{d.id} \t#{u.email} \tnot found: #{File.basename(fname)}"
            # DocumentMailer.file_not_found_email(d, u).deliver
          end
        end
      end
      nn += 1
    end
    logger.info "All: #{nn} docs, but #{nf} files not found"
  end

  desc 'Create documents from files'
  task create_documents_from_files: :environment do # создание новых документов из файов в каталоге
    require 'find'

    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :create_documents_from_files'

    nn = 1
    nf = 0
    pathfrom = 'files/_1_Нормативные документы банка/__Внутренние документы Банка_действующие/'
    d = Dir.new(pathfrom)

    Find.find(pathfrom) do |f| # обход всех файлов в каталогах с документами
      next if File.stat(f).directory?
      nf += 1
      fname = f[pathfrom.size..-1]
      logger.info "#{nf} #{fname}"
    end
    logger.info "All: #{nn} docs, but #{nf} files not found"
  end

  desc 'Check_bproces_roles'
  task check_bproces_roles: :environment do # рассылка о процессах, в которых не выделены роли
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproces_roles'
    processes_count = 0
    processes_without_roles = 0
    u = User.find(97) # пользователь по умолчанию
    Bproce.all.each do |bproce| # все процессы
      if Bproce.where('lft>? and rgt<?', bproce.lft, bproce.rgt).count.zero? # если это конечный процесс - без подпроцессов
        if bproce.business_roles.count.zero?
          processes_without_roles += 1
          mail_to = u # DEBUG
          mail_to = bproce.user if bproce.user # владелец процесса
          BproceMailer.process_without_roles(bproce, mail_to).deliver
        end
      end
      processes_count += 1
    end
    logger.info "      Processes: #{processes_count}, but #{processes_without_roles} hasn't roles"
  end

  desc 'Check bproces_owner access roles'
  task check_bproces_owners: :environment do # рассылка о владельцах процессов, не имеющих необходимых ролей доступа
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproces_owners'
    owners_count = 0
    users_without_roles = 0
    u = User.find(97) # пользователь по умолчанию
    Bproce.group(:user_id).all.each do |bproce| # все владельцы процессов
      next unless bproce.user_id # есть владелец процесса?
      @user = bproce.user
      unless @user.role? :owner
        users_without_roles += 1
        logger.info "      #{@user.displayname} hasn't roles :owner"
      end
      owners_count += 1
    end
    logger.info "      Process owners: #{owners_count}, but #{users_without_roles} hasn't roles :owner"
  end

  desc 'Migrate document.bproce_id to BproceDocuments: document can related to many bprocesses'
  task migrate_bproce_id_to_bprocedocument: :environment do # перенос ссылок на процесс из документа Document.bproce_id в BproceDocument
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :bproce_id_to_bprocedocument'
    document_count = 0
    bproce_count = 0
    Document.all.each do |document| # все документы
      document_count += 1
      if document.bproce_id # есть процесса?
        BproceDocument.create(bproce_id: document.bproce_id, document_id: document.id, purpose: 'основной')
        bproce_count += 1
      end
    end
    logger.info "      Migrates #{bproce_count} processes from #{document_count} documents"
  end

  desc 'Each documents must have link to bproces'
  task check_bproce_document_for_all_documents: :environment do # проверить наличие процесса для каждого документа
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproce_document_for_all_documents'
    document_count = 0
    wo_bproce_count = 0
    Document.all.each do |document| # все документы
      document_count += 1
      if document.bproce_documents.count < 1 # есть процесса?
        puts document.id, document.owner.displayname
        wo_bproce_count += 1
      end
    end
    logger.info "      #{wo_bproce_count} dcouments without processes from #{document_count} documents"
  end

  desc 'List users from ActiveDirectory'
  task list_active_directory_users: :environment do # вывод списка пользователей LDAP для тестирования
    require 'rubygems'
    require 'net/ldap'

    PublicActivity.enabled = false # отключить протоколирование изменений

    LDAP_CONFIG = YAML.load_file(Devise.ldap_config) # считаем конфиги доступа к LDAP
    ldap = Net::LDAP.new host: LDAP_CONFIG['development']['host'],
                         port: LDAP_CONFIG['development']['port'],
                         auth: {
                           method: :simple,
                           username: LDAP_CONFIG['development']['admin_user'],
                           password: LDAP_CONFIG['development']['admin_password']
                         }
    filter = Net::LDAP::Filter.eq('memberOf', 'CN=rl_bp1step_users,OU=roles,DC=ad,DC=bankperm,DC=ru') # выбирать членов группы rl_bp1step_users
    treebase = LDAP_CONFIG['development']['base']
    attrs = %w[sn givenname middleName cn telephonenumber sAMAccountName title physicaldeliveryofficename department name mail description userAccountControl]

    i = 0 # счетчики
    ldap.search(base: treebase, attributes: attrs, filter: filter) do |entry|
      i += 1
      email = entry['mail'].first # это обязательные параметры + к ним левые уникальные password и reset_password_token
      username = entry['sAMAccountName'].first.downcase
      uac = entry['userAccountControl'].first.to_i # второй бит = 1 означает отключенного пользователя в AD
      department = entry['department'].first.to_s.force_encoding('UTF-8')
      position = entry['title'].first.to_s.force_encoding('UTF-8')
      phone = entry['telephonenumber'].first
      office = entry['physicaldeliveryofficename'].first
      sn = entry['sn'].first
      givenname = entry['givenname'].first
      middlename = entry['middleName'].first
      physicaldeliveryofficename = entry['physicaldeliveryofficename'].first
      name = entry['name'].first

      # puts "#{i}. #{username}\t#{email}\t#{sn} #{givenname} #{middlename}\t#{name}   >> #{uac & 2}"
      puts "#{i}. #{name}\t#{email}\t#{position} - #{department}"
    end
  end
end
# rubocop:enable
