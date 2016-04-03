# coding: utf-8
class User < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  has_attached_file :avatar, 
    styles: { medium: "300x300>", mini: "50x50#" }, processors: [:cropper],
    default_url: "/store/images/:style/missing.png",
    url: "/store/images/:id.:style.:extension"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  do_not_validate_attachment_file_type :avatar  #paperclip >4.0

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
  has_many :document, through: :user_document
  has_many :user_document, dependent: :destroy


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # аутентификация - через БД
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  # аутентификация - через LDAP
  #devise :ldap_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
   
  before_create :create_role

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, 
    :firstname, :lastname, :displayname, :role_ids, 
    :avatar, 
    :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  #after_update :reprocess_pic, :if => :cropping?

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  def reprocess_avatar
    avatar.reprocess!
  end

  #before_save :get_ldap_lastname, :get_ldap_firstname, :get_ldap_displayname, :get_ldap_email

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def get_ldap_lastname
    #Rails::logger.info("### Getting the users last name")
    tempname = Devise::LdapAdapter.get_ldap_param(self.username,"sn").to_s
    tempname = tempname.force_encoding("UTF-8")
    #puts "\tLDAP returned lastname of " + tempname
    self.lastname = tempname
  end 

  def get_ldap_firstname
    #Rails::logger.info("### Getting the users first name")
    tempname = Devise::LdapAdapter.get_ldap_param(self.username,"givenname").to_s
    tempname = tempname.force_encoding("UTF-8")
    #puts "\tLDAP returned firstname of " + tempname
    self.firstname = tempname
  end 

  def get_ldap_displayname
    #Rails::logger.info("### Getting the users display name")
    tempname = Devise::LdapAdapter.get_ldap_param(self.username,"displayname").to_s
    self.displayname = tempname.force_encoding("UTF-8")
  end 

  def get_ldap_email
    #Rails::logger.info("### Getting the users email address")
    tempmail = Devise::LdapAdapter.get_ldap_param(self.username,"mail").to_s
    self.email = tempmail
  end

  
  #def get_ldap_email
  #  self.email = Devise::LdapAdapter get_ldap_param(self.username,"mail")
  #end

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
