# frozen_string_literal: true

class Iresource < ApplicationRecord
  validates :label, presence: true,
                    uniqueness: true,
                    length: { minimum: 3, maximum: 20 }
  validates :location, presence: true,
                       length: { minimum: 3, maximum: 255 }

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :user, optional: true
  has_many :bproce_iresources, dependent: :destroy
  has_many :bproces, through: :bproce_iresources

  def owner_name
    user.try(:displayname)
  end

  def owner_name=(name)
    self.user = User.find_by(displayname: name) if name.present?
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('label ILIKE ? or location ILIKE ? or id = ?', "%#{search}%", "%#{search}%", search.to_i.to_s)
  end
end
