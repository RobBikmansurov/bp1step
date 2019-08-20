# frozen_string_literal: true

class BproceDocument < ApplicationRecord
  include BproceNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :bproce
  belongs_to :document

  validates :bproce_id, presence: true
  validates :document_id, presence: true
end
