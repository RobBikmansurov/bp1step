# encoding: utf-8
# утилиты для поддержки работы BP1Step

namespace :bp1step do

  desc "Email testing"
  task :test_email  => :environment do    # тестирование отправки email в production
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :test_email'
    u = User.find(97) # пользователь по умолчанию
    mail_to = u   # DEBUG dlevel <2 - только документы 1 уровня
    document = Document.last
    DocumentMailer.file_not_found_email(document, mail_to).deliver  # рассылка об отсутствии файла документа
    bproce = Bproce.last
    BproceMailer.process_without_roles(bproce, mail_to).deliver
  end

  desc "LDAP search testing"
  task test_ldap: :environment do
    require 'rubygems'
    require 'net/ldap'
    LDAP_CONFIG = YAML.load_file(Devise.ldap_config)  # считаем конфиги доступа к LDAP
    ldap = Net::LDAP.new :host => LDAP_CONFIG["development"]["host"],
      :port => LDAP_CONFIG["development"]["port"],
      :auth => {
        :method => :simple,
        :username => LDAP_CONFIG["development"]["admin_user"],
        :password => LDAP_CONFIG["development"]["admin_password"]
      }
    puts "#{ldap.host}:#{ldap.port}"
    if ldap.bind
      puts "Success!!"
    else
      puts "Failed!"
      puts ldap.get_operation_result
    end

    filter = Net::LDAP::Filter.eq('memberOf', 'CN=rl_bp1step_users,OU=roles,DC=ad,DC=bankperm,DC=ru') # выбирать членов группы rl_bp1step_users
    treebase = LDAP_CONFIG["development"]["base"]
    attrs = ["sn", "givenname", "middleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description", "userAccountControl"]

    i, j = 0, 0  # счетчики
    s = ''
    ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
      i += 1
      j += 1
      username = entry["sAMAccountName"].first.downcase
      s += " \t#{username}"
      if j > 4
        puts "#{i-4}. #{s}"
        j = 0
        s = ''
      end
    end
  end

  desc "LDAP authentificate testing"
  task test_ldap_auth: :environment do
    require 'rubygems'
    require 'net/ldap'
    require 'highline/import'
    LDAP_CONFIG = YAML.load_file(Devise.ldap_config)  # считаем конфиги доступа к LDAP
    ldap = Net::LDAP.new :host => LDAP_CONFIG["development"]["host"],
      :port => LDAP_CONFIG["development"]["port"],
      :auth => {
        :method => :simple,
        :username => LDAP_CONFIG["development"]["admin_user"],
        :password => LDAP_CONFIG["development"]["admin_password"]
      }
    puts "\n#{ldap.host}:#{ldap.port}"
    username = ask("Username: ")
    username = "CN=#{username},OU=Services,DC=ad,DC=bankperm,DC=ru"
    puts "Username:" + username
    password = ask("Password: ") { |q| q.echo = false }
    if ldap.bind
      puts "Success bind!!"
    else
      puts "Failed!"
    end
    puts ldap.get_operation_result
    ldap.auth username, password
    puts ldap.get_operation_result
  end

  desc "Sync users from ActiveDirectory"
  # отбирает пользователей - членов группы rl_bp1step_users
  task :sync_active_directory_users  => :environment do   # синхронизация списка пользователей LDAP -> User 
    require 'rubygems'
    require 'net/ldap'

    PublicActivity.enabled = false  # отключить протоколирование изменений
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :sync_active_directory_users'

    LDAP_CONFIG = YAML.load_file(Devise.ldap_config)  # считаем конфиги доступа к LDAP
    ldap = Net::LDAP.new :host => LDAP_CONFIG["development"]["host"],
      :port => LDAP_CONFIG["development"]["port"],
      :auth => {
        :method => :simple,
        :username => LDAP_CONFIG["development"]["admin_user"],
        :password => LDAP_CONFIG["development"]["admin_password"]
      }
    debug_flag = false # флаг отладки, если true - отладочная печать

    filter = Net::LDAP::Filter.eq('memberOf', 'CN=rl_bp1step_users,OU=roles,DC=ad,DC=bankperm,DC=ru') # выбирать членов группы rl_bp1step_users
    treebase = LDAP_CONFIG["development"]["base"]
    attrs = ["sn", "givenname", "middleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description", "userAccountControl"]

    i, new_users, upd_users, not_found_users, disabled_users = 0, 0, 0, 0, 0  # счетчики
    ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
      i += 1
      username = entry["sAMAccountName"].first.downcase
      email = entry["mail"].first       # это обязательные параметры + к ним левые уникальные password и reset_password_token
      #puts "#{i}. #{username}\t#{email}" if debug_flag
      email = username + '@bankperm.ru' if email.to_s.empty?
      uac = entry["userAccountControl"].first.to_i  # второй бит = 1 означает отключенного пользователя в AD
      department = entry["department"].first.to_s.force_encoding("UTF-8")
      position = entry["title"].first.to_s.force_encoding("UTF-8")
      phone = entry["telephonenumber"].first
      office = entry["physicaldeliveryofficename"].first
      sn = entry["sn"].first
      givenname = entry["givenname"].first
      firstname = entry["firstname"].first
      middlename = entry["middlename"].first
      lastname = entry["lastname"].first.to_s
      displayname = entry["name"].first.to_s
      physicaldeliveryofficename = entry["physicaldeliveryofficename"].first
      #logger.info "#{i}. #{username}\t#{email}\t#{sn} #{givenname} #{middlename}\t#{name}   >> #{uac & 2}" if debug_flag
      #logger.info "#{i}. #{name}\t#{email}\t#{position} - #{department}" if debug_flag
      #puts "#{i}. #{username}\t#{email}\t#{displayname}" if debug_flag

      if uac & 2 == 0  or !entry["mail"].first.to_s.empty?   # пользователь не заблокирован и имеет не пустой e-mail
        usr = User.find_or_create_by(username: username)
        if usr.new_record?
          logger.info "#{i}!#{new_users}. #{entry.sAMAccountName} #{entry.dn} \t- email is NULL!" if email.to_s.empty?
          new_users += 1
          usr1 = User.find_by_email(email.to_s) # поищем по e-mail
          if usr1.nil?
            logger.info "+ #{entry["sn"].first} \t[#{username}] \t"
            usr.update_attribute(:username, username)
            usr.update_attribute(:email, email)
            usr.update_attribute(:department, department)
            usr.update_attribute(:position, position)
            usr.update_attribute(:phone, phone)
            usr.update_attribute(:office, office)
            usr.update_attribute(:password, email)
            usr.update_attribute(:firstname, firstname)
            usr.update_attribute(:middlename, middlename)
            usr.update_attribute(:lastname, lastname)
            #usr.update_attribute(:displayname, name)   # ФИО - модель update_from_ldap
            logger.info "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} #{entry.dn}"
            logger.info usr.errors if debug_flag
          else
            logger.info "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} = #{usr1.username}"
            logger.info "    уже есть пользователь с таким e-mail, #id= #{usr1.id}"
          end
        else  # проверим - не изменилось ли ключевые реквизиты у этого пользователя в AD
          #puts "#{i}. #{username}\t#{email}\t#{displayname}" if debug_flag

          if !(usr.email == email)  # e-mail
            logger.info "#{usr.email} == #{email}: #{usr.email == email}" if debug_flag
            usr.update_attribute(:email, email)
            usr.email = email
          end
          if !(usr.department.to_s == department) # подразделение
            logger.info "#{usr.id}: #{usr.department} = #{department}: #{usr.department == department}" if debug_flag
            usr.update_attribute(:department, department)
          end
          if !(usr.position.to_s == position) # должность
            logger.info "#{usr.id}: #{usr.position} = #{position}: #{usr.position == position}" if debug_flag
            usr.update_attribute(:position, position)
          end
          usr.update_attribute(:phone, phone) if !(usr.phone == phone) # телефон
          usr.update_attribute(:office, office) if !(usr.office == office) # офис
          usr.update_attribute(:middlename, middlename) if !(usr.middlename == middlename) # отчество
          #usr.update_attribute(:displayname, displayname) if !(usr.displayname == displayname) # ФИО - модель update_from_ldap
          #puts "#{i}. #{username}\t#{email}\t#{displayname} #{if (usr.displayname == displayname) ? '=' : '#'} #{(usr.displayname)}" if debug_flag

          logger.info "#{entry["sn"].first} \t[#{username}] \t #{usr.changed}" if usr.changed?
        end
      else  # пользователь заблокирован в AD
        usr = User.find_by_username(username)   # поищем в БД
        if !usr.nil?
          disabled_users += 1
          usr.update_attribute(:active, false)
          logger.info "#{i}!#{disabled_users}. #{entry.sAMAccountName} #{entry.dn} \t- disabled user!"
        end
      end
    end
    logger.info "LDAP users total: #{i}, add: #{new_users}, disable: #{disabled_users} users"

    i, disabled_users = 0, 0
    User.all.each do |user|     # проверим: все ли пользователи есть в LDAP
      i += 1
      filter = Net::LDAP::Filter.eq("sAMAccountName", user.username)
      exist_user = 0
      ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do | entry |  # есть в LDAP?
        exist_user += 1
        uac = entry["userAccountControl"].first.to_i
        groups = Devise::LDAP::Adapter.get_ldap_param(user.username, "memberOf")  # группы пользователя
        #puts groups.grep(/rl_bp1step/) 
        if groups && groups.grep(/rl_bp1step_users/).blank? # если не член группы rl_bp1step
          user.update_attribute(:active, false) # делаем неактивным
          disabled_users += 1
          # если нет связи с ролями, рабочими местами, процессами
          if user.workplaces.count == 0 and user.business_roles.count == 0 and user.bproce_ids.count == 0
            user.delete # удалим
            logger.info "#{i}!#{disabled_users}. ##{user.id} #{user.username}\t #{user.displayname} \t- DELETE user!"
          else
            logger.info "#{i}!#{disabled_users}. ##{user.id} #{user.username}\t #{user.displayname}\t - need DELETE:"
            s = ''
            user.workplaces.each do | wp |
              s = s + wp.name + '  '
            end
            logger.info "\t workplaces: #{s}" 
            s = ''
            user.business_roles.each do | brole |
              s = s + brole.name + '  '
            end
            logger.info "\t business roles: #{s}" 
          end
        else
          user.update_attribute(:active, true) # делаем активным
        end
      end
      logger.info "#{i} #{user.displayname} - not found in LDAP!" if i == 0
    end
    logger.info "  DB users total: #{i}, not found in LDAP: #{not_found_users}, disable: #{disabled_users} users"
    logger.info "  #{ldap.get_operation_result}" if debug_flag
  end


  desc "Check document files in eplace location"
  task :check_document_files_eplace  => :environment do     # проверка наличия файлов документов в каталоге
    # TODO добавить конфиги для константы "files"

    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_document_files'

    nn = 1
    nf = 0
    u = User.find(97)
    Document.all.each do |d|
      fname = d.eplace
      if !fname.nil?   # если указано имя файла документа
        if fname.size > 20
          fname = "files" + d.file_name         # добавим путь к файлам
          if File.exist?(fname)
          else
            nf += 1
            if !d.owner_id.nil?
              #u = User.find(d.owner_id)
            end
            logger.info "##{d.id} \t#{u.email} \tnot found: #{File.basename(fname)}"
            #DocumentMailer.file_not_found_email(d, u).deliver
          end
        end
      end
      nn += 1
    end
    logger.info "All: #{nn} docs, but #{nf} files not found"
  end


  desc "Check document_file for documents with level 1-3 "
  task :check_document_files  => :environment do    # проверка наличия файла документа для документов уровня 1-3 (кроме 4 - Свидетельства)
    # TODO контролировать все уровни документов кроме 4
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_document_files'
    documents_count = 0
    documents_file_missing = 0
    files_missing  = 0
    processes_missing = 0
    pdfs_missing  = 0
    DEBUG = false
    u = User.find(97) # пользователь по умолчанию
    Document.where('dlevel = 4').each do |document| # все документы типа Свидетельств должны иметь процесс
      documents_count += 1
      if document.owner_id
        mail_to = document.owner
        mail_to = u if DEBUG
      else
        mail_to = u
      end
      if document.bproce.count == 0
        processes_missing += 1
        logger.info "process missing ##{document.id}: \t #{mail_to.email}" 
        DocumentMailer.process_is_missing_email(document, mail_to).deliver  # рассылка о необходимости указания процесса для документа
      end
    end
    Document.where('dlevel < 4').where(:status =>"Утвержден").each do |document| # все документы кроме Свидетельств
      documents_count += 1
      if document.owner_id
        mail_to = document.owner
        mail_to = u if DEBUG
      else
        mail_to = u
      end
      if document.bproce.count == 0
        processes_missing += 1
        logger.info "process missing ##{document.id}: \t #{mail_to.email}" 
        DocumentMailer.process_is_missing_email(document, mail_to).deliver  # рассылка о необходимости указания процесса для документа
      end
      if document.document_file_file_name 
        if File.exist?(document.document_file.path)  # есть исходный файл документа
          if File.size(document.document_file.path) == document.document_file_file_size
            if !File.exist?(document.pdf_path)  # есть PDF для просмотра
              Paperclip.run('unoconv', "-f pdf #{document.document_file.path}")
              pdfs_missing += 1
            end
          else
            logger.info "file is corrupted ##{document.id}: #{document.document_file_file_size} <> #{File.size(document.document_file.path)} \t #{mail_to.email}" 
            DocumentMailer.file_is_corrupted_email(document, mail_to).deliver  # рассылка о необходимости новой загрузки файла документа
          end
        else
          files_missing += 1
          DocumentMailer.file_is_corrupted_email(document, mail_to).deliver  # рассылка о необходимости новой загрузки файла документа
          logger.info "file is missing ##{document.id}: #{document.document_file_file_name} \t #{mail_to.email}"
        end
      else
        if !document.note.start_with?('ДСП')  #  если это не ДСП - должен быть файл
          documents_file_missing += 1
          DocumentMailer.file_not_found_email(document, mail_to).deliver  # рассылка об отсутствии файла документа
          logger.info "file name is missing ##{document.id}: #{document.name} \t #{mail_to.email}"
        end
      end
    end
    logger.info "All: #{documents_count} docs, #{documents_file_missing} file names missing, #{files_missing} files missing, #{pdfs_missing} pdfs missing, #{processes_missing} without processes"
  end


  desc "Create documents from files"
  task :create_documents_from_files  => :environment do     # создание новых документов из файов в каталоге
    require 'find'

    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :create_documents_from_files'

    nn = 1
    nf = 0
    pathfrom = 'files/_1_Нормативные документы банка/__Внутренние документы Банка_действующие/'
    d = Dir.new(pathfrom)

    Find.find( pathfrom ) do |f|  # обход всех файлов в каталогах с документами
      if not File.stat(f).directory?
        nf += 1
        fname = f[pathfrom.size..-1]
        logger.info '#{nf} #{fname}'
      end
    end
    logger.info 'All: #{nn} docs, but #{nf} files not found'
  end


  desc 'Check_bproces_roles'
  task :check_bproces_roles => :environment do  # рассылка о процессах, в которых не выделены роли
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproces_roles'
    processes_count = 0
    processes_without_roles = 0
    u = User.find(97) # пользователь по умолчанию
    Bproce.all.each do |bproce| # все процессы
      if Bproce.where("lft>? and rgt<?", bproce.lft, bproce.rgt).count == 0 # если это конечный процесс - без подпроцессов
        if bproce.business_roles.count == 0
          processes_without_roles += 1
          mail_to = u # DEBUG
          mail_to = bproce.user if bproce.user   # владелец процесса
          BproceMailer.process_without_roles(bproce, mail_to).deliver
        end
      end
      processes_count += 1
    end
    logger.info "      Processes: #{processes_count}, but #{processes_without_roles} hasn't roles"
  end


  desc 'Check bproces_owner access roles'
  task :check_bproces_owners => :environment do  # рассылка о владельцах процессов, не имеющих необходимых ролей доступа
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproces_owners'
    owners_count = 0
    users_without_roles = 0
    u = User.find(97) # пользователь по умолчанию
    Bproce.group(:user_id).all.each do |bproce| # все владельцы процессов
      if bproce.user_id  # есть владелец процесса?
        @user = bproce.user
        if !@user.has_role? :owner
          users_without_roles += 1
          logger.info "      #{@user.displayname} hasn't roles :owner"
        end
        owners_count += 1
      end
    end
    logger.info "      Process owners: #{owners_count}, but #{users_without_roles} hasn't roles :owner"
  end


  desc 'Migrate document.bproce_id to BproceDocuments: document can related to many bprocesses'
  task :migrate_bproce_id_to_bprocedocument => :environment do  # перенос ссылок на процесс из документа Document.bproce_id в BproceDocument
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :bproce_id_to_bprocedocument'
    document_count = 0
    bproce_count = 0
    Document.all.each do |document| # все документы
      document_count += 1
      if document.bproce_id  # есть процесса?
        BproceDocument.create(bproce_id: document.bproce_id, document_id: document.id, purpose: 'основной')
        bproce_count += 1
      end
    end
    logger.info "      Migrates #{bproce_count} processes from #{document_count} documents"
  end


  desc 'Each documents must have link to bproces'
  task :check_bproce_document_for_all_documents => :environment do  # проверить наличие процесса для каждого документа
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproce_document_for_all_documents'
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


  desc "List users from ActiveDirectory"
  task :list_active_directory_users  => :environment do   # вывод списка пользователей LDAP для тестирования
    require 'rubygems'
    require 'net/ldap'

    PublicActivity.enabled = false  # отключить протоколирование изменений

    LDAP_CONFIG = YAML.load_file(Devise.ldap_config)  # считаем конфиги доступа к LDAP
    ldap = Net::LDAP.new :host => LDAP_CONFIG["development"]["host"],
      :port => LDAP_CONFIG["development"]["port"],
      :auth => {
        :method => :simple,
        :username => LDAP_CONFIG["development"]["admin_user"],
        :password => LDAP_CONFIG["development"]["admin_password"]
      }
    filter = Net::LDAP::Filter.eq('memberOf', 'CN=rl_bp1step_users,OU=roles,DC=ad,DC=bankperm,DC=ru') # выбирать членов группы rl_bp1step_users
    treebase = LDAP_CONFIG["development"]["base"]
    attrs = ["sn", "givenname", "middleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description", "userAccountControl"]

    i = 0  # счетчики
    ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
      i += 1
      email = entry["mail"].first       # это обязательные параметры + к ним левые уникальные password и reset_password_token
      username = entry["sAMAccountName"].first.downcase
      uac = entry["userAccountControl"].first.to_i  # второй бит = 1 означает отключенного пользователя в AD
      department = entry["department"].first.to_s.force_encoding("UTF-8")
      position = entry["title"].first.to_s.force_encoding("UTF-8")
      phone = entry["telephonenumber"].first
      office = entry["physicaldeliveryofficename"].first
      sn = entry["sn"].first
      givenname = entry["givenname"].first
      middlename = entry["middleName"].first
      physicaldeliveryofficename = entry["physicaldeliveryofficename"].first
      name = entry["name"].first

      #puts "#{i}. #{username}\t#{email}\t#{sn} #{givenname} #{middlename}\t#{name}   >> #{uac & 2}"
      puts "#{i}. #{name}\t#{email}\t#{position} - #{department}"
    end
  end

  desc 'Each contracts must have link to bproces'
  task :check_bproce_contract_for_all_contracts => :environment do  # проверить наличие процесса для каждого договора
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproce_contract_for_all_contracts'
    contract_count = 0
    wo_bproce_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.all.each do |contract| # все договоры
      contract_count += 1
      if contract.bproce_contract.count < 1  # есть процессы?
        #puts contract.id, contract.owner.displayname
        wo_bproce_count += 1
        mail_to = u # DEBUG
        mail_to = contract.owner if contract.owner   # ответственный за договор
        ContractMailer.process_is_missing_email(contract, mail_to).deliver
        logger.info "      ##{contract.id.to_s} \t#{contract.owner.displayname}"
      end
    end
    logger.info "      #{wo_bproce_count} contracts without processes from #{contract_count} contracts"
  end

  desc 'Сontrol executed (outdated) contracts'
  task :check_outdated_contracts => :environment do  # проверить договоры с истекшим сроком окончания - запускается ежеддневно
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_outdated_contracts'
    outdated_contracts_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.where("date_end <= ?", Date.current).where(status: "Действует").each do | contract |  # просроченные договоры
      outdated_contracts_count += 1
      emails = u.email # DEBUG
      emails = contract.owner.email.to_s if contract.owner   # ответственный за договор
      emails += ", " + contract.payer.email.to_s if contract.payer
      ContractMailer.check_outdated_contracts(contract, emails, 'прекратил').deliver
      logger.info "      ##{contract.id.to_s} \t#{emails}"
    end
    logger.info "      #{outdated_contracts_count} contracts is outdated"
  end

  desc 'Сontrol of expiring contracts'
  task :check_expiring_contracts => :environment do  # проверить договоры с истекашим сроком окончания - запускается по ПН
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_expiring_contracts'
    expiring_contracts_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.where("date_end BETWEEN ? AND ?", Date.current, Date.current + 8).where(status: "Действует").each do | contract |  # договоры со сроком действия -2 и + 7 дней от Пн
      expiring_contracts_count += 1
      emails = u.email # DEBUG
      emails = contract.owner.email.to_s if contract.owner   # ответственный за договор
      emails += ", " + contract.payer.email.to_s if contract.payer
      ContractMailer.check_outdated_contracts(contract, emails, 'прекращает').deliver
      logger.info "      ##{contract.id.to_s} \t#{emails}"
    end
    logger.info "      #{expiring_contracts_count} contracts is expiring from #{Date.current - 2} to #{Date.current + 7}" 
  end

  desc "Create Letters from files in  SVK"
  task :create_letters_from_files  => :environment do     # создание новых писем из файов в каталоге СВК
    PublicActivity.enabled = false  # отключить протоколирование изменений
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :create_letters_from_files'

    nn = 0
    nf = 0
    pathfrom =  Rails.root.join("public", 'store', "REMART")
    logger.info "#{pathfrom.to_s}"

    for file in Dir.glob(pathfrom.join('*.*').to_s)    # обход всех файлов в каталоге с файлами для писем
      nf += 1
      ext = File.extname(file).upcase
      fname = File.basename(file).upcase            # расширение файла
      name = fname[0..(fname.size - ext.size - 1)]  # только имя файла
      l_number, l_subject, l_sender = ""
      l_date = Date.current.strftime('%d.%m.%Y')
      l_source = 'СВК'

      case name
      when /\AOD\d{3,}\z/                                 # ODNNNN.PDF
        l_number = 'ОД-' + name[2..name.size]
        l_sender = 'ЦБ РФ'
        l_subject = 'Об отзыве лицензии / Об уточнении'
      when /\A\d{3,}\z/                                   #NNNN.PDF или NNNN.TIF
        l_number = name
        l_sender = 'Отделение по Пермскому краю ЦБ РФ'
        l_subject = name
      #when /\AVES\d{6}_\d{1,}\(\d{1,}\)/
      when /\AVES\d{6}_+/                                 # вестник банка росии
        l_number = name[/_\d+\(?f?/]
        l_number = "#{l_number[1..l_number.size-2]}"
        l_number = "#{l_number.to_i.to_s} #{name[/\(\d+\)?f?/]}"
        l_sender = "Банк России"
        l_subject = "Вестник Банка России No #{l_number} от #{l_date}"
      when /\AGR-OT-\d+/                                  # gr-ot-MM.DOC
        l_number = name
        l_sender = 'Отделение по Пермскому краю ЦБ РФ'
        l_subject = "График представления отчетности в виде электронных сообщений"
      when /\A\d+_U/                                      # Указание БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size-2]}-У"
        l_sender = "Банк России"
        l_subject = "Указание Банка России № #{l_number} от #{l_date}"
      when /\A\d+_MR/                                     # Методические рекомендации
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size-2]}-МР"
        l_sender = "Банк России"
        l_subject = "Методические рекомендации № #{l_number} от #{l_date}"
      else
        # неизвестные файлы не добавляем
      end

      if !l_number.blank? # удалось идентифицировать файл
        letter = Letter.new(status: 0, )
        letter.date = Time.current.strftime("%d.%m.%Y")
        letter.duedate = (Time.current + 10.days).strftime("%d.%m.%Y") # срок исполнения - даем 10 дней по умолчанию
        letter.number = l_number
        letter.sender = l_sender
        letter.subject = l_subject
        letter.source = l_source
        if letter.save!    # письмо создали, теперь присоедним файл
          nn += 1
          logger.info "##{letter.id} #{name}: \t№#{l_number}\t[#{l_subject}]"
          letter_appendix = LetterAppendix.new(letter_id: letter.id)
          File.open file do | f |
            letter_appendix.appendix = f
            letter_appendix.save!
          end

          File.rename(file, File.join(File.dirname(file), 'ARC', File.basename(file))) if File.exist?(file)   # перенеем в архив

        end
      end
    end

    logger.info "All: #{nf} files, created #{nn} letters"
  end

  
  desc 'Сontrol of expiring duedate letters'
  task :check_overdue_letters => :environment do  # проверить письма с просроченным сроком исполениия
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_overdue_letters'

    count = 0
    Letter.overdue.each do | letter |  # письма в статусе < Исполнено со сроком исполнения <= текущей дате
      count += 1
      emails = ''
      emails = "#{letter.author.email}" if letter.author   # автор
      letter.user_letter.each do |user_letter|  # исполнители
        emails += ', ' if !emails.blank?
        emails += "#{user_letter.user.email}" if user_letter.user
      end
      logger.info "      ##{letter.id}\tсрок = #{letter.duedate.strftime("%d.%m.%Y")}\t#{emails}"
      #emails = 'robb@bankperm.ru'
      LetterMailer.check_overdue_letters(letter, emails).deliver_now if !emails.blank?
    end
    logger.info "      #{count} letters is duedate" 
  end



end
