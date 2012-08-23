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

	filter = Net::LDAP::Filter.eq("title", "*")	# пользователи обязательно имеют должность
	#filter = Net::LDAP::Filter.eq("sAMAccountName", "mr_rob")
	#filter = Net::LDAP::Filter.eq(&(objectClass=person)(objectClass=user)(middleName=*)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))
	treebase = LDAP_CONFIG["development"]["base"]
	attrs = ["sn", "givenname", "MiddleName", "cn", "telephonenumber", "sAMAccountName", "title", "physicaldeliveryofficename", "department", "name", "mail", "description"]

	i, new_users, upd_users = 0, 0, 0	# счетчики
	ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
	#ldap.search(:base => treebase, :filter => filter) do |entry|
		i = i + 1
  		email = entry["mail"].first				# это обязательные параметры + к ним левые уникальные password и reset_password_token
  		username = entry["sAMAccountName"].first.downcase
  		puts username, email
	    usr = User.find_or_create_by_email :username => username, :email => email, :password => username
	    if usr.new_record?
	    	new_users = new_users + 1
	        usr.save
			puts "#{i}+#{new_users}. #{entry.sAMAccountName} #{entry.dn}"
	    else	# а здесь надо проверить - не изменилось ли что либо у этого пользователя в AD
	    	f_change = 0
			if usr.department != entry["department"].first	# подразделение
				usr.department = entry["department"].first
				f_change += 1
			end
			if usr.position != entry["title"].first	# должность
				usr.position = entry["title"].first
				f_change += 1
			end
			if usr.phone != entry["telephonenumber"].first	# телефон
				usr.phone = entry["telephonenumber"].first
				f_change += 1
			end

			if usr.office != entry["physicaldeliveryofficename"].first	# офис
				usr.office = entry["physicaldeliveryofficename"].first
				f_change += 1
			end
			if f_change > 0
	    		upd_users = upd_users + 1
				puts "#{i}=#{upd_users}. #{entry.sAMAccountName} #{entry.dn}"
	      		usr.save
	      	end
	    end

	end
	puts "All: #{i}, add: #{new_users}, update: #{upd_users} users"
	#p ldap.get_operation_result
  end
end
