# coding: utf-8
class User < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  
  has_many :user_business_role  # бизнес-роли пользователя
  has_many :business_roles, :through => :user_business_role
  has_many :user_workplace # рабочие места пользователя
  has_many :workplaces, :through => :user_workplace 
  has_many :user_roles, :dependent => :destroy  # роли доступа пользователя
  has_many :roles, :through => :user_roles
  has_many :bproce
  has_many :iresource

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # аутентификация - через БД
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  # аутентификация - через LDAP
  devise :ldap_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
   
  before_create :create_role

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :displayname, :role_ids
  before_save :update_from_ldap

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def update_from_ldap
    if !self.username.blank?
      if !Devise::LDAP::Adapter.get_ldap_param(self.username, "mail").nil?
        self.email = Devise::LDAP::Adapter.get_ldap_param(self.username, "mail").first.to_s
        tempname = Devise::LDAP::Adapter.get_ldap_param(self.username, "sn").first.to_s
        self.lastname = tempname.force_encoding("UTF-8")
        tempname = Devise::LDAP::Adapter.get_ldap_param(self.username, "givenname").first.to_s
        self.firstname = tempname.force_encoding("UTF-8")
        tempname = Devise::LDAP::Adapter.get_ldap_param(self.username, "displayname").first.to_s
        self.displayname = tempname.force_encoding("UTF-8")
      end
    end
  end 

  def self.search(search)
   if search
      where('username ILIKE ? or displayname ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end
  
  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  private
    def create_role
      self.roles << Role.find_by_name(:user)  #  if ENV["RAILS_ENV"] != 'test' 
    end
end
