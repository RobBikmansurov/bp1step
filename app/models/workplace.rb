# frozen_string_literal: true

class Workplace < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :designation, presence: true,
                          uniqueness: true,
                          length: { minimum: 5, maximum: 50 }

  has_many :bproce_workplaces
  has_many :bproces, through: :bproce_workplaces
  has_many :user_workplace # пользователи рабочего миеста
  has_many :users, through: :user_workplace

  accepts_nested_attributes_for :bproce_workplaces, allow_destroy: true
  accepts_nested_attributes_for :bproces

  # attr_accessible :designation, :name, :switch, :port, :description, :typical, :location, :workplace_id, :date_from, :date_to, :note
  # has_many :bapps

  def self.search(search)
    return where(nil) if search.blank?
    
    where('designation ILIKE ? or name ILIKE ? or description ILIKE ? or id = ?',
          "%#{search}%", "%#{search}%", "%#{search}%", search.to_i.to_s)
  end
end
