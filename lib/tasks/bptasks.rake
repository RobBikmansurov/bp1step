# encoding: utf-8
# утилиты для поддержки работы BP1Step
namespace :bp1step do
  desc "Sync users from ActiveDirectory"
  task :sync_active_directory_users  => :environment do 		# синхронизация списка пользователей с AD
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
	#host = LDAP_CONFIG['audiocast_uri_format']
	debug_flag = true

	#filter = Net::LDAP::Filter.eq("title", "*")	# пользователи обязательно имеют должность
	#filter = Net::LDAP::Filter.eq("sAMAccountName", "mr_rob")
	filter = Net::LDAP::Filter.eq("sAMAccountName", "bb26")
	#filter = Net::LDAP::Filter.eq(&(objectClass=person)(objectClass=user)(middleName=*)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))
	treebase = LDAP_CONFIG["development"]["base"]
	attrs = ["sn", "givenname", "MiddleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description"]

	i, new_users, upd_users = 0, 0, 0	# счетчики
	ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
	#ldap.search(:base => treebase, :filter => filter) do |entry|
		i = i + 1
  		email = entry["mail"].first				# это обязательные параметры + к ним левые уникальные password и reset_password_token
  		username = entry["sAMAccountName"].first.downcase
#	    usr = User.find_or_create_by_email :username => username, :email => email, :password => email
	    usr = User.find_or_create_by_username :username => username, :email => email, :password => email
	    puts "#{entry["sn"].first} [#{username}]"
	    if usr.new_record?
			if email.to_s.empty?	# пропустим с пустым email
				puts "#{i}!#{new_users}. #{entry.sAMAccountName} #{entry.dn} email is NULL!"
			else
	    		new_users = new_users + 1
	    		usr1 = User.find_by_email(email.to_s)	# поищем по e-mail
	    		if usr1.nil?
	        		usr.save
					puts "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} #{entry.dn}"
	        		puts usr.errors
	        	else
					puts "#{i}+#{new_users}. #{entry.sAMAccountName} #{email} = #{usr1.username}"
					puts "    уже есть пользователь с таким e-mail, #id= #{usr1.id}"
	        	end
	        end
	    else	# а здесь надо проверить - не изменилось ли что либо у этого пользователя в AD
			#puts usr.department.encoding
	    	s1 = entry["department"].first.to_s.force_encoding("UTF-8")
	    	#puts str.encoding
			if !(usr.department == s1)	# подразделение
				puts "#{usr.department} = #{entry['department'].first}: #{usr.department == entry['department'].first}" if debug_flag
				usr.update_attribute(:department, entry["department"].first)
			end
	    	s2 = entry["title"].first.to_s.force_encoding("UTF-8")
			if !(usr.position == s2)	# должность
				puts "#{usr.position} = #{entry['title'].first}: #{usr.position == entry['title'].first}" if debug_flag
				usr.update_attribute(:position, entry["title"].first)
			end
			if !(usr.phone == entry["telephonenumber"].first)	# телефон
				puts "#{usr.phone} = #{entry['telephonenumber'].first}: #{usr.phone == entry['telephonenumber'].first}" if debug_flag
				usr.update_attribute(:phone, entry["telephonenumber"].first)
			end
			if !(usr.office == entry["physicaldeliveryofficename"].first)	# офис
				usr.update_attribute(:office, entry["physicaldeliveryofficename"].first)
				puts "#{usr.office} = #{entry['physicaldeliveryofficename'].first}: #{usr.office == entry['physicaldeliveryofficename'].first}" if debug_flag
			end
	    end

	end
	puts "All: #{i}, add: #{new_users}, update: #{upd_users} users"
	p ldap.get_operation_result
  end

  desc "Sync users from ActiveDirectory"
  task :sync_document_files  => :environment do 		# синхронизация списка документов с файлами
	d = Dir.new("files")
	d.each  {|x| puts "Got #{x}" }
  end
end
