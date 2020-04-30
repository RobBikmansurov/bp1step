# frozen_string_literal: true

# Agent
class Agent < ApplicationRecord
  # attr_accessible :shortname, :name, :town, :address, :contacts, :agent_name, :note

  has_many :contract, through: :agent_contract
  has_many :agent_contract, dependent: :destroy

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 255 }
  validates :town, length: { maximum: 30 }
  validates :shortname, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }

  belongs_to :responsible, class_name: 'User', optional: true

  def self.search(search)
    return where(nil) if search.blank?

    where('name ILIKE ? or shortname ILIKE ? or contacts ILIKE ? or id = ? or inn ILIKE ?',
          "%#{search}%", "%#{search}%", "%#{search}%", search.to_i.to_s, "%#{search}%")
  end

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def fullname
    city = ", г. #{town}" if town.present?

    "\"#{name}\"#{city}"
  end

  def identify
    tax = " ИНН #{inn}"

    "Контрагент (##{id}) #{fullname}#{tax}"
  end

  def responsible_name
    responsible.try(:displayname)
  end

  def responsible_name=(name)
    self.responsible = User.find_by(displayname: name) if name.present?
  end

end
