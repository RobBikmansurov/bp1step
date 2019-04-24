# frozen_string_literal: true

class Role < ApplicationRecord
  validates :name, uniqueness: true,
                   presence: true,
                   length: { minimum: 4 }
  validates :description, presence: true

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  # attr_accessible :name, :description, :note

  def self.search(search)
    return where(nil) if search.blank?

    where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
  end
end
