# frozen_string_literal: true
class BusinessRole < ActiveRecord::Base
  validates :name, presence: true,
                   length: { minimum: 5, maximum: 50 }
  validates :description, presence: true,
                          length: { minimum: 8 }
  validates :bproce_id, presence: true

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }
  self.per_page = 10

  # бизнес-роль участвует в процессе
  belongs_to :bproce
  # бизнес-роль может исполняться многими пользователями
  has_many :user_business_role, dependent: :destroy # пользователь может иметь много ролей
  has_many :users, through: :user_business_role

  attr_accessible :name, :description, :bproce_id, :bproce_name, :features

  default_scope { order(:name) }

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by(name: name).id if name.present?
  end

  def self.search(search, page)
    paginate page: page,
             conditions: ['name ILIKE ? or description ILIKE ? or id = ?', "%#{search}%", "%#{search}%", search.to_i.to_s]
  end
end
