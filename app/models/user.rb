# coding: utf-8
class User < ActiveRecord::Base
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  
  has_many :user_business_role  # бизнес-роли пользователя
  has_many :business_roles, :through => :user_business_role
  has_many :user_workplace # рабочие места пользователя
  has_many :workplaces, :through => :user_workplace 
  has_many :user_roles, :dependent => :destroy  # роли доступа пользователя
  has_many :roles, :through => :user_roles
  has_many :bproce
  has_many :documents
  has_many :iresource

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # аутентификация - через БД
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  # аутентификация - через LDAP
  devise :ldap_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
   
  before_create :create_role

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  #before_save :get_ldap_email
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :displayname, :role_ids
  #attr_accessible :username, :email, :password
  before_save :get_ldap_lastname, :get_ldap_firstname, :get_ldap_displayname, :get_ldap_email

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def get_ldap_lastname
    s = Devise::LdapAdapter.get_ldap_param(self.username,"sn")
    s = s.to_s.force_encoding("UTF-8")
    self.lastname = s
  end 

  def get_ldap_firstname
    s = Devise::LdapAdapter.get_ldap_param(self.username,"givenname")
    s = s.to_s.force_encoding("UTF-8")
    self.firstname = s
  end 

  def get_ldap_displayname
    s = Devise::LdapAdapter.get_ldap_param(self.username,"displayname")
    s = s.to_s.force_encoding("UTF-8")
    self.displayname = s
  end 

  def get_ldap_email
      tempmail = Devise::LdapAdapter.get_ldap_param(self.username,"mail")
      self.email = tempmail
  end

  def self.search(search)
   if search
      where('username LIKE ? or displayname LIKE ? or firstname LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  private
    def create_role
      self.roles << Role.find_by_name(:user)  if ENV["RAILS_ENV"] != 'test' 
    end
end
