# frozen_string_literal: true

namespace :bp1step do
  desc 'Sync users from ActiveDirectory'
  # отбирает пользователей - членов группы rl_bp1step_users
  task sync_active_directory_users: :environment do # синхронизация списка пользователей LDAP -> User
    require 'rubygems'
    require 'net/ldap'

    PublicActivity.enabled = false # отключить протоколирование изменений
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :sync_active_directory_users'

    LDAP_CONFIG = YAML.load_file(Devise.ldap_config) # считаем конфиги доступа к LDAP
    ldap = ldap_connection(LDAP_CONFIG)

    debug_flag = false # флаг отладки, если true - отладочная печать

    filter = Net::LDAP::Filter.eq('memberOf', 'CN=rl_bp1step_users,OU=roles,DC=ad,DC=bankperm,DC=ru') # выбирать членов группы rl_bp1step_users
    treebase = LDAP_CONFIG['development']['base']
    attrs = %w[sn givenname middleName cn telephonenumber sAMAccountName title physicaldeliveryofficename department name mail description userAccountControl]

    i = 0
    new_users = 0
    not_found_users = 0
    disabled_users = 0 # счетчики
    ldap.search(base: treebase, attributes: attrs, filter: filter) do |entry|
      i += 1
      # next if i < 95

      username = entry['sAMAccountName'].first.downcase
      email = entry['mail'].first # это обязательные параметры + к ним левые уникальные password и reset_password_token
      # puts "#{i}. #{username}\t#{email}" if debug_flag
      email = username + '@bankperm.ru' if email.to_s.empty?
      uac = entry['userAccountControl'].first.to_i # второй бит = 1 означает отключенного пользователя в AD
      department = entry['department'].first.to_s.force_encoding('UTF-8')
      position = entry['title'].first.to_s.force_encoding('UTF-8')
      phone = entry['telephonenumber'].first
      office = entry['physicaldeliveryofficename'].first
      sn = entry['sn'].first
      # givenname = entry['givenname'].first
      firstname = entry['givenname'].first
      firstname = firstname.force_encoding('UTF-8') if firstname
      middlename = entry['middlename'].first
      middlename = middlename.force_encoding('UTF-8') if middlename
      lastname = entry['sn'].first.force_encoding('UTF-8')
      displayname = entry['name'].first.force_encoding('UTF-8')
      physicaldeliveryofficename = entry['physicaldeliveryofficename'].first
      # logger.info "#{i}. #{username}\t#{email}\t#{sn} #{givenname} #{middlename}\t#{name}   >> #{uac & 2}" if debug_flag
      # logger.info "#{i}. #{name}\t#{email}\t#{position} - #{department}" if debug_flag
      puts "#{i}. #{username}\t#{email}\t#{displayname}" if debug_flag

      if (uac & 2).zero? || !entry['mail'].first.to_s.empty? # пользователь не заблокирован и имеет не пустой e-mail
        usr = User.find_or_create_by(username: username)
        if usr.new_record?
          logger.info "#{i}!#{new_users}. #{entry.sAMAccountName} #{entry.dn} \t- email is NULL!" if email.to_s.empty?
          new_users += 1
          usr1 = User.find_by(email: email.to_s) # поищем по e-mail
          if usr1.nil?
            logger.info "+ #{entry['sn'].first} \t[#{username}] \t"
            usr.update_column(:username, username)
            usr.update_column(:email, email)
            usr.update_column(:department, department)
            usr.update_column(:position, position)
            usr.update_column(:phone, phone)
            usr.update_column(:office, office)
            usr.update_column(:password, email)
            usr.update_column(:firstname, firstname)
            usr.update_column(:middlename, middlename)
            usr.update_column(:lastname, lastname)
            # usr.update_column(:displayname, name)   # ФИО - модель update_from_ldap
            logger.info "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} #{entry.dn}"
            logger.info usr.errors if debug_flag
          else
            logger.info "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} = #{usr1.username}"
            logger.info "    уже есть пользователь с таким e-mail, #id= #{usr1.id}"
          end
        else # проверим - не изменилось ли ключевые реквизиты у этого пользователя в AD
          puts "#{i} update. #{username}\t#{email}\t#{displayname}" if debug_flag

          usr.update_column(:firstname, firstname) unless usr.firstname == firstname
          usr.update_column(:lastname, lastname) unless usr.lastname == lastname
          usr.update_column(:middlename, middlename) unless usr.middlename == middlename
          usr.update_column(:displayname, displayname) unless usr.displayname == displayname

          unless usr.email == email # e-mail
            logger.info "#{usr.email} == #{email}: #{usr.email == email}" if debug_flag
            usr.update_column(:email, email)
            usr.email = email
          end
          unless usr.department.to_s == department # подразделение
            logger.info "#{usr.id}: #{usr.department} = #{department}: #{usr.department == department}" if debug_flag
            usr.update_column(:department, department)
          end
          unless usr.position.to_s == position # должность
            logger.info "#{usr.id}: #{usr.position} = #{position}: #{usr.position == position}" if debug_flag
            usr.update_column(:position, position)
          end
          usr.update_column(:phone, phone) unless usr.phone == phone # телефон
          usr.update_column(:office, office) unless usr.office == office # офис
          usr.update_column(:middlename, middlename) unless usr.middlename == middlename # отчество
          # usr.update_column(:displayname, displayname) if !(usr.displayname == displayname) # ФИО - модель update_from_ldap
          # puts "#{i}. #{username}\t#{email}\t#{displayname} #{if (usr.displayname == displayname) ? '=' : '#'} #{(usr.displayname)}" if debug_flag

          logger.info "#{entry['sn'].first} \t[#{username}] \t #{usr.changed}" if usr.changed?
        end
      else # пользователь заблокирован в AD
        usr = User.find_by(username: username) # поищем в БД
        unless usr.nil?
          disabled_users += 1
          usr.update_column(:active, false)
          logger.info "#{i}!#{disabled_users}. #{entry.sAMAccountName} #{entry.dn} \t- disabled user!"
        end
      end
    end
    logger.info "LDAP users total: #{i}, add: #{new_users}, disable: #{disabled_users} users"

    i = 0
    disabled_users = 0
    User.all.each do |user| # проверим: все ли пользователи есть в LDAP
      i += 1
      # puts "#{i}. #{user.username}\t#{user.email}\t#{user.displayname}" if debug_flag
      filter = Net::LDAP::Filter.eq('sAMAccountName', user.username)
      exist_user = 0
      ldap.search(base: treebase, attributes: attrs, filter: filter) do |entry| # есть в LDAP?
        exist_user += 1
        uac = entry['userAccountControl'].first.to_i
        groups = Devise::LDAP::Adapter.get_ldap_param(user.username, 'memberOf') # группы пользователя
        if groups&.grep(/rl_bp1step_users/).blank? # если не член группы rl_bp1step
          user.update_column(:active, false) # делаем неактивным
          disabled_users += 1
          # если нет связи с ролями, рабочими местами, процессами, задачами
          if user.workplaces.any? || user.business_roles.any? || user.bproce.any? || UserTask.where(user_id: user.id).any?
            logger.info "#{i}!#{disabled_users}. ##{user.id} #{user.username}\t #{user.displayname}\t - need DELETE:"
            s = user.bproce.pluck(:name).join(',')
            logger.info "\t bprocesses: #{s}" if s.present?
            s = user.workplaces.pluck(:name).join(',')
            logger.info "\t workplaces: #{s}" if s.present?
            s = user.business_roles.pluck(:name).join(', ')
            logger.info "\t business roles: #{s}" if s.present?
            s = UserTask.where(user_id: user.id).pluck(:id).join(', ')
            logger.info "\t tasks: #{s}" if s.present?
          else
            user.destroy # удалим
            logger.info "#{i}!#{disabled_users}. ##{user.id} #{user.username}\t #{user.displayname} \t- DESTROYED!"
          end
        else
          user.update_column(:active, true) # делаем активным - член группы rl_bp1step_users
        end
      end
      logger.info "#{i} #{user.displayname} - not found in LDAP!" if i.zero?
    end
    logger.info "  DB users total: #{i}, not found in LDAP: #{not_found_users}, disable: #{disabled_users} users"
    logger.info "  #{ldap.get_operation_result}" if debug_flag
  end

  def ldap_connection(config)
    Net::LDAP.new host: config['development']['host'],
                  port: config['development']['port'],
                  auth: {
                    method: :simple,
                    username: config['development']['admin_user'],
                    password: config['development']['admin_password']
                  }
  end
end
