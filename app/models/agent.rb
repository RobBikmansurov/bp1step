# frozen_string_literal: true

# Agent
class Agent < ApplicationRecord
  has_many :agent_contract, dependent: :destroy
  has_many :contract, through: :agent_contract

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 255 }
  validates :town, length: { maximum: 30 }
  validates :shortname, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }

  belongs_to :responsible, class_name: 'User', optional: true

  def self.search(search)
    return where(nil) if search.blank?
    return where('inn ILIKE ?', "%#{search}") if search.to_i > 1_000_000
    return where('id = ?', search[1..-1].to_i) if search.start_with? '#'

    where('name ILIKE ? or shortname ILIKE ? or contacts ILIKE ?',
          "%#{search}%", "%#{search}%", "%#{search}%")
  end

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  def fullname
    city = ", г. #{town}" if town.present?

    "\"#{name}\"#{city}"
  end

  def identify
    tax = " ИНН #{inn}" if inn.present?

    "Контрагент (##{id}) #{fullname}#{tax}"
  end

  def responsible_name
    responsible.try(:displayname)
  end

  def responsible_name=(name)
    self.responsible = User.find_by(displayname: name) if name.present?
  end
end
