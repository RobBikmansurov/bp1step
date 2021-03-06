# frozen_string_literal: true

class BproceWorkplace < ApplicationRecord
  include BproceNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :bproce_id, presence: true
  validates :workplace_id, presence: true

  belongs_to :bproce
  belongs_to :workplace

  # attr_accessible :workplace_id, :bproce_id

  def workplace_designation
    workplace.try(:designation)
  end

  def workplace_designation=(name)
    self.workplace_id = Workplace.find_by(designation: name).id if name.present?
  end
end
