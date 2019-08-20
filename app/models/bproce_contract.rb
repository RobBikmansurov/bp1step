# frozen_string_literal: true

class BproceContract < ApplicationRecord
  include BproceNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :bproce
  belongs_to :contract

  validates :bproce_id, presence: true
  validates :contract_id, presence: true
end
