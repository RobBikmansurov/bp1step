# frozen_string_literal: true

class Term < ApplicationRecord
  include PublicActivity::Common
  # include PublicActivity::Model
  # tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :shortname, uniqueness: true,
                        length: { minimum: 2, maximum: 50 }
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 200 }
  validates :description, presence: true

  # attr_accessible :name, :shortname, :description, :note, :source

  def self.search(search)
    return where(nil) if search.blank?

    where('shortname ILIKE ? or name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
