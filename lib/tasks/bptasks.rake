# encoding: utf-8
# утилиты для поддержки работы BP1Step

namespace :bp1step do
  desc "Sync users from ActiveDirectory"
  task :sync_active_directory_users  => :environment do 	# синхронизация списка пользователей LDAP -> User
  															# не умеет удалять пользователей User, удаленных в LDAP
    require 'rubygems'
    require 'net/ldap'
    LDAP_CONFIG = YAML.load_file(Devise.ldap_config)	# считаем конфиги доступа к LDAP
    ldap = Net::LDAP.new :host => LDAP_CONFIG["development"]["host"],
        :port => LDAP_CONFIG["development"]["port"],
        :auth => {
            :method => :simple,
            :username => LDAP_CONFIG["development"]["admin_user"],
            :password => LDAP_CONFIG["development"]["admin_password"]
     	}
	debug_flag = true	# флаг отладки, если true - отладочная печать

	#filter = Net::LDAP::Filter.eq(&(objectClass=person)(objectClass=user)(middleName=*)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))
	c1 = Net::LDAP::Filter.eq('objectCategory', 'Person')
	c2 = Net::LDAP::Filter.eq('objectClass', 'user')
	c3 = Net::LDAP::Filter.eq('samAccountType', '805306368')
	c4 = Net::LDAP::Filter.eq('title', '*')		# пользователи с должностью
	c5 = Net::LDAP::Filter.eq('mail', '*')		# имеют e-mail
	c6 = Net::LDAP::Filter.ne('userAccountControl', '2')	# не заблокированные (не отключенные) - 'userAccountControl:1.2.840.113556.1.4.803:', '2'
	filter = c1 & c2 & c3 & c4 & c5 & c6	#выбрать только учетные записи пользователей, имеющих атрибут title и не заблокированных. 
	treebase = LDAP_CONFIG["development"]["base"]
	attrs = ["sn", "givenname", "MiddleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description", "userAccountControl"]

	i, new_users, upd_users, not_found_users, disabled_users = 0, 0, 0, 0, 0	# счетчики
	ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
		i += 1
  		email = entry["mail"].first				# это обязательные параметры + к ним левые уникальные password и reset_password_token
  		username = entry["sAMAccountName"].first.downcase
  		#puts "#{username} #{email}" if debug_flag
  		uac = entry["userAccountControl"].first.to_i	# второй бит = 1 означает отключенного пользователя в AD
		if uac & 2 == 0	# пользователь не заблокирован
		    usr = User.find_or_create_by_username :username => username, :email => email, :password => email
		    if usr.new_record?
				if email.to_s.empty?	# пропустим с пустым email
					puts "#{i}!#{new_users}. #{entry.sAMAccountName} #{entry.dn} \t- email is NULL!"
				else
		    		new_users += 1
		    		usr1 = User.find_by_email(email.to_s)	# поищем по e-mail
		    		if usr1.nil?
					    puts "+ #{entry["sn"].first} \t[#{username}] \t"
		        		usr.save
						puts "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} #{entry.dn}"
		        		puts usr.errors
		        	else
						puts "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} = #{usr1.username}"
						puts "    уже есть пользователь с таким e-mail, #id= #{usr1.id}"
		        	end
		        end
		    else	# проверим - не изменилось ли ключевые реквизиты у этого пользователя в AD
				if !(usr.email == email)	# e-mail
					puts "#{usr.email} = #{email}: #{usr.email == email}" if debug_flag
					usr.update_attribute(:email, email)
					usr.email = email
				end
		    	s1 = entry["department"].first.to_s.force_encoding("UTF-8")
				if !(usr.department.to_s == s1)	# подразделение
					puts "#{usr.id}: #{usr.department} = #{s1}: #{usr.department == s1}" if debug_flag
					usr.update_attribute(:department, s1)
				end
		    	s2 = entry["title"].first.to_s.force_encoding("UTF-8")
				if !(usr.position.to_s == s2)	# должность
					puts "#{usr.id}: #{usr.position} = #{s2}: #{usr.position == s2}" if debug_flag
					usr.update_attribute(:position, s2)
				end
				if !(usr.phone == entry["telephonenumber"].first)	# телефон
					#puts "#{usr.phone} = #{entry['telephonenumber'].first}: #{usr.phone == entry['telephonenumber'].first}" if debug_flag
					usr.update_attribute(:phone, entry["telephonenumber"].first)
				end
				if !(usr.office == entry["physicaldeliveryofficename"].first)	# офис
					usr.update_attribute(:office, entry["physicaldeliveryofficename"].first)
					#puts "#{usr.office} = #{entry['physicaldeliveryofficename'].first}: #{usr.office == entry['physicaldeliveryofficename'].first}" if debug_flag
				end
			    puts "#{entry["sn"].first} \t[#{username}] \t #{usr.changed}" if usr.changed?
		    end
	  	else	# пользователь заблокирован в AD
		    usr = User.find_by_username(username) 	# поищем в БД
		    if !usr.nil?
		    	disabled_users += 1
		    	#usr.delete	# надо бы удалить, но вдруг на него есть ссылки
		    	puts "#{i}!#{disabled_users}. #{entry.sAMAccountName} #{entry.dn} \t- disabled user!"
		    end
	  	end
	end
	puts "LDAP users total: #{i}, add: #{new_users}, disable: #{disabled_users} users"

	i, disabled_users = 0, 0
	User.all.each do |user|			# проверим: все ли пользователи есть в LDAP
		i += 1
		filter = Net::LDAP::Filter.eq("sAMAccountName", user.username)
		exist_user = 0
		ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do | entry |
			exist_user += 1
			uac = entry["userAccountControl"].first.to_i
			if uac & 2 > 0
		    	disabled_users += 1
		    	# если нет связи с ролями, рабочими местами, процессами
		    	if user.workplaces.count == 0 and user.roles.count == 0 and user.bproce_ids.count == 0
			    	user.delete	# удалим
			    	puts "#{i}!#{disabled_users}. #{entry.sAMAccountName} #{entry.dn} \t- DELETE user!"
			    end
			end
		end
		puts "#{i} #{user.displayname} - not found in LDAP!" if i == 0
	end
	puts "  DB users total: #{i}, not found in LDAP: #{not_found_users}, disable: #{disabled_users} users"
	p ldap.get_operation_result
  end



  desc "Check document files in eplace location"
  task :check_document_files  => :environment do 		# проверка наличия файлов документов в каталоге
    # TODO добавить конфиги для константы "files"
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
            puts "##{d.id} \t- file not found: \t#{File.basename(fname)}"
            if !d.owner_id.nil?
              u = User.find(d.owner_id)
            end
            DocumentMailer.file_not_found_email(d, u).deliver
          end
        end
      end
      nn += 1
	end
    puts "All: #{nn} docs, but #{nf} files not found"
  end




  desc "Create documents from files"
  task :create_documents_from_files  => :environment do 		# создание новых документов из файов в каталоге
    # TODO добавить конфиги для константы "files"
    # TODO добавить mailer - отправлять письмо ответственному за документ об отсутствии файла документа
    require 'find'
    nn = 1
    nf = 0
    pathfrom = 'files/_1_Нормативные документы банка/__Внутренние документы Банка_действующие/'
    d = Dir.new(pathfrom)

	Find.find( pathfrom ) do |f|	# обход всех файлов в каталогах с джокументами
  		if not File.stat(f).directory?
  			nf += 1
  			fname = f[pathfrom.size..-1]
  			puts "#{nf} #{fname}"
  		end
	end
    puts "All: #{nn} docs, but #{nf} files not found"
  end


end
