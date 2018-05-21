# frozen_string_literal: true

class User < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  has_attached_file :avatar,
                    styles: { medium: '300x300>', mini: '50x50#' },
                    processors: [:cropper],
                    presence: false,
                    default_url: '/store/images/:style/missing.png',
                    url: '/store/images/:id.:style.:extension',
                    path: ':rails_root/public/store/images/:id.:style.:extension'
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\Z}
  do_not_validate_attachment_file_type :avatar # paperclip >4.0
  validates :avatar, attachment_presence: false

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_many :user_business_role # бизнес-роли пользователя
  has_many :business_roles, through: :user_business_role
  has_many :user_workplace # рабочие места пользователя
  has_many :workplaces, through: :user_workplace
  has_many :user_roles, dependent: :destroy # роли доступа пользователя
  has_many :roles, through: :user_roles
  has_many :bproce
  has_many :iresource
  has_many :document, through: :user_document
  has_many :user_document, dependent: :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # аутентификация - через БД
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  # аутентификация - через LDAP
  devise :ldap_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # before_create :create_role
  after_create :create_role
  before_save :ldap_email, :ldap_firstname, :ldap_displayname, :ldap_email

  # attr_accessible :username, :email, :password, :password_confirmation, :remember_me,
  #                :firstname, :lastname, :displayname, :role_ids,
  #                :middlename, :office, :position, :phone, :department,
  #                :avatar,
  #                :crop_x, :crop_y, :crop_w, :crop_h,
  #                :middlename, :office, :position, :phone
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  # after_update :reprocess_pic, :if => :cropping?

  def cropping?
    crop_x.present? && crop_y.present? && crop_w.present? && crop_h.present?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  def reprocess_avatar
    avatar.reprocess!
  end

  # before_save :ldap_email, :ldap_firstname, :ldap_displayname, :ldap_email

  def role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def ldap_lastname
    lastname = Devise::LDAP::Adapter.get_ldap_param(username, 'sn')
    lastname.first.force_encoding('UTF-8') if lastname
  end

  def ldap_firstname
    tempname = Devise::LDAP::Adapter.get_ldap_param(username, 'givenname')
    tempname.first.force_encoding('UTF-8') if tempname
  end

  def ldap_displayname
    Devise::LDAP::Adapter.get_ldap_param(username, 'displayname')
  end

  def ldap_email
    Devise::LDAP::Adapter.get_ldap_param(username, 'mail')
  end

  def self.search(search)
    if search
      where('username ILIKE ? or displayname ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

  def user_name
    self.try(:displayname)
  end

  def user_name=(name)
    self.id = User.find_by(displayname: name).id if name.present?
  end

  private

  def create_role
    roles << Role.find_by(name: :user) if ENV['RAILS_ENV'] != 'test'
  end
end
