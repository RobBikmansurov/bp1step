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


  desc "Sync users from ActiveDirectory"
  # не умеет удалять пользователей User, удаленных в LDAP
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

    #filter = Net::LDAP::Filter.eq(&(objectClass=person)(objectClass=user)(middleName=*)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))
    c1 = Net::LDAP::Filter.eq('objectCategory', 'Person')
    c2 = Net::LDAP::Filter.eq('objectClass', 'user')
    c3 = Net::LDAP::Filter.eq('samAccountType', '805306368')
    c4 = Net::LDAP::Filter.eq('title', '*')   # пользователи с должностью
    c5 = Net::LDAP::Filter.eq('mail', '*')    # имеют e-mail
    c6 = Net::LDAP::Filter.ne('userAccountControl', '2')  # не заблокированные (не отключенные) - 'userAccountControl:1.2.840.113556.1.4.803:', '2'
    filter = c1 & c2 & c3 & c4 & c5 & c6  #выбрать только учетные записи пользователей, имеющих атрибут title и не заблокированных. 
    treebase = LDAP_CONFIG["development"]["base"]
    attrs = ["sn", "givenname", "MiddleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description", "userAccountControl"]

    i, new_users, upd_users, not_found_users, disabled_users = 0, 0, 0, 0, 0  # счетчики
    ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
      i += 1
      email = entry["mail"].first       # это обязательные параметры + к ним левые уникальные password и reset_password_token
      username = entry["sAMAccountName"].first.downcase
      uac = entry["userAccountControl"].first.to_i  # второй бит = 1 означает отключенного пользователя в AD
      #logger.info "#{username} #{email} >> #{uac & 2}" if debug_flag
      if uac & 2 == 0 # пользователь не заблокирован
        s1 = entry["department"].first.to_s.force_encoding("UTF-8")
        s2 = entry["title"].first.to_s.force_encoding("UTF-8")
        usr = User.find_or_create_by(username: username)
        if usr.new_record?
          #usr.email = email
          #usr.password = email
          if email.to_s.empty?  # пропустим с пустым email
            logger.info "#{i}!#{new_users}. #{entry.sAMAccountName} #{entry.dn} \t- email is NULL!"
          else
            new_users += 1
            usr1 = User.find_by_email(email.to_s) # поищем по e-mail
            if usr1.nil?
              logger.info "+ #{entry["sn"].first} \t[#{username}] \t"
              #usr = User.new
              usr.update_attribute(:username, username)
              usr.update_attribute(:email, email)
              usr.update_attribute(:department, s1)
              usr.update_attribute(:position, s2)
              usr.update_attribute(:phone, entry["telephonenumber"].first)
              usr.update_attribute(:office, entry["physicaldeliveryofficename"].first)
              usr.update_attribute(:password, email)
              logger.info "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} #{entry.dn}"
              logger.info usr.errors if debug_flag
            else
              logger.info "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} = #{usr1.username}"
              logger.info "    уже есть пользователь с таким e-mail, #id= #{usr1.id}"
            end
          end
        else  # проверим - не изменилось ли ключевые реквизиты у этого пользователя в AD
          if !(usr.email == email)  # e-mail
            logger.info "#{usr.email} == #{email}: #{usr.email == email}" if debug_flag
            usr.update_attribute(:email, email)
            usr.email = email
          end
          if !(usr.department.to_s == s1) # подразделение
            logger.info "#{usr.id}: #{usr.department} = #{s1}: #{usr.department == s1}" if debug_flag
            usr.update_attribute(:department, s1)
          end
          if !(usr.position.to_s == s2) # должность
            logger.info "#{usr.id}: #{usr.position} = #{s2}: #{usr.position == s2}" if debug_flag
            usr.update_attribute(:position, s2)
          end
          if !(usr.phone == entry["telephonenumber"].first) # телефон
            #logger.info "#{usr.phone} = #{entry['telephonenumber'].first}: #{usr.phone == entry['telephonenumber'].first}" if debug_flag
            usr.update_attribute(:phone, entry["telephonenumber"].first)
          end
          if !(usr.office == entry["physicaldeliveryofficename"].first) # офис
            usr.update_attribute(:office, entry["physicaldeliveryofficename"].first)
            #logger.info "#{usr.office} = #{entry['physicaldeliveryofficename'].first}: #{usr.office == entry['physicaldeliveryofficename'].first}" if debug_flag
          end
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
      ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do | entry |
        exist_user += 1
        uac = entry["userAccountControl"].first.to_i
        if uac & 2 > 0  # имеющийся в БД пользователь заблокирован в AD
          user.update_attribute(:active, false)
          disabled_users += 1
          # если нет связи с ролями, рабочими местами, процессами
          if user.workplaces.count == 0 and user.business_roles.count == 0 and user.bproce_ids.count == 0
            user.delete # удалим
            logger.info "#{i}!#{disabled_users}. #{entry.sAMAccountName} #{entry.dn} \t- DELETE user!"
          else
            logger.info "#{i}!#{disabled_users}. #{entry.sAMAccountName} #{entry.dn}\t - need DELETE:"
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

    Find.find( pathfrom ) do |f|  # обход всех файлов в каталогах с джокументами
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


end
