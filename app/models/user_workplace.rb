# frozen_string_literal: true

class UserWorkplace < ApplicationRecord
  include UserNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  # attr_accessible :workplace_id

  validates :user_id, presence: true
  validates :workplace_id, presence: true

  belongs_to :user
  belongs_to :workplace
end
