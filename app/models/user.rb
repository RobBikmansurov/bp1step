# frozen_string_literal: true

class User < ApplicationRecord
  include LDAP
  self.per_page = 20

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

  has_many :user_business_role, dependent: :destroy # бизнес-роли пользователя
  has_many :business_roles, through: :user_business_role
  has_many :user_workplace, dependent: :destroy # рабочие места пользователя
  has_many :workplaces, through: :user_workplace
  has_many :user_roles, dependent: :destroy # роли доступа пользователя
  has_many :roles, through: :user_roles
  has_many :bproce, dependent: :destroy
  has_many :iresource, dependent: :destroy
  has_many :user_document, dependent: :destroy
  has_many :document, through: :user_document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # аутентификация - через БД
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  # аутентификация - через LDAP
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # before_create :create_role
  after_create :create_role
  attr_accessor :disable_ldap
  before_save :ldap_email, :ldap_firstname, :ldap_displayname, :ldap_email unless :disable_ldap

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
    roles.any? { |role| role.name.underscore.to_sym == role_sym }
  end

  def business_role?(business_role_id)
    return false if id.blank?

    UserBusinessRole.where(user_id: id, business_role_id: business_role_id).any?
  end

  def executor_in?(bproce_id)
    return false if id.blank?

    business_role_ids = BusinessRole.where(bproce_id: bproce_id).pluck :id
    UserBusinessRole.where(user_id: id, business_role_id: business_role_ids).any?
  end

  def executor_of?(bproce_id, role_name)
    return false if id.blank?

    business_role_ids = BusinessRole.where(bproce_id: bproce_id, name: role_name).pluck :id
    UserBusinessRole.where(user_id: id, business_role_id: business_role_ids).any?
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('username ILIKE ? or displayname ILIKE ?', "%#{search}%", "%#{search}%")
  end

  def user3
    "#{firstname&.chr}#{middlename&.chr}#{lastname&.chr}".upcase
  end

  def user_name
    try(:displayname)
  end

  def user_name=(name)
    self.id = User.find_by(displayname: name).id if name.present?
  end

  private

  def create_role
    roles << Role.find_by(name: :user) if ENV['RAILS_ENV'] != 'test'
  end
end
