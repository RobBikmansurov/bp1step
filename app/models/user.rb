class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  #before_save :get_ldap_email
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :displayname
  #attr_accessible :username, :email, :password
  before_save :get_ldap_lastname, :get_ldap_firstname, :get_ldap_displayname, :get_ldap_email

  def get_ldap_lastname
      #Rails::logger.info("### Getting the users last name")
      tempname = Devise::LdapAdapter.get_ldap_param(self.username,"sn")
      tempname = tempname.force_encoding("UTF-8")
      #puts "\tLDAP returned lastname of " + tempname
      self.lastname = tempname
  end 

  def get_ldap_firstname
      #Rails::logger.info("### Getting the users first name")
      tempname = Devise::LdapAdapter.get_ldap_param(self.username,"givenname")
      tempname = tempname.force_encoding("UTF-8")
      #puts "\tLDAP returned firstname of " + tempname
      self.firstname = tempname
  end 

  def get_ldap_displayname
      #Rails::logger.info("### Getting the users display name")
      tempname = Devise::LdapAdapter.get_ldap_param(self.username,"displayname")
      self.displayname = tempname.force_encoding("UTF-8")
  end 

  def get_ldap_email
      #Rails::logger.info("### Getting the users email address")
      tempmail = Devise::LdapAdapter.get_ldap_param(self.username,"mail")
      self.email = tempmail
  end

  
  #def get_ldap_email
  #  self.email = Devise::LdapAdapter get_ldap_param(self.username,"mail")
  #end

  def self.search(search)
   if search
      where('username LIKE ? or displayname LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end


end
