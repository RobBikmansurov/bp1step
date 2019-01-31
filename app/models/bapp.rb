# frozen_string_literal: true

class Bapp < ApplicationRecord
  acts_as_taggable

  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 4, maximum: 50 }
  validates :description, presence: true

  has_many :bproce_bapps
  has_many :bproces, through: :bproce_bapps
  accepts_nested_attributes_for :bproce_bapps, allow_destroy: true
  accepts_nested_attributes_for :bproces

  # attr_accessible :name, :description, :apptype, :purpose, :version_app,
  #                :directory_app, :distribution_app, :executable_file,
  #                :licence, :source_app, :note, :tag_list

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def self.search(search)
    return where(nil) if search.blank?

    where('name ILIKE ? or description ILIKE ? or id = ?', "%#{search}%", "%#{search}%", search.to_i.to_s)
  end

  def self.searchtype(search)
    return where(nil) if search.blank?

    where('apptype ILIKE ? ', "%#{search}%")
  end
end
