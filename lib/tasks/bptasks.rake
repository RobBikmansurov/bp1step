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

	i, new_users, upd_users = 0
	ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
	#ldap.search(:base => treebase, :filter => filter) do |entry|
		i = i + 1
  		email = entry["mail"].first				# это обязательные параметры + к ним левые уникальные password и reset_password_token
  		username = entry["sAMAccountName"].first.downcase
  		puts username, email
	    usr = User.find_or_create_by_email :username => username, :email => email, :password => username
	    if usr.new_record?
	        usr.save
			puts "#{i}. #{entry.sAMAccountName} #{entry.dn}"
	    else	# а здесь надо проверить - не изменилось ли что либо у этого пользователя в AD
	      	#usr.save
	    end

	end
	puts i, new_users, upd_users
	p ldap.get_operation_result
  end
end
