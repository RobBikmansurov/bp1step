# frozen_string_literal: true

class BproceBapp < ApplicationRecord
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :bproce_id, presence: true
  validates :bapp_id, presence: true
  validates :apurpose, presence: true

  belongs_to :bproce
  belongs_to :bapp

  # attr_accessible :id, :bproce_id, :bapp_id, :apurpose, :bproce_name, :bapp_name

  def bapp_name
    bapp.try(:description)
  end

  def bapp_name=(name)
    self.bapp_id = Bapp.find_by(name: name).id if name.present?
  end

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by(name: name).id if name.present?
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
  end
end
