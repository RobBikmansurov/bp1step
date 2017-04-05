# frozen_string_literal: true

class BproceDocument < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :bproce
  belongs_to :document

  validates :bproce_id, presence: true
  validates :document_id, presence: true

  attr_accessible :bproce_id, :document_id, :purpose, :bproce_name

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by(name: name).id if name.present?
  end
end
