# frozen_string_literal: true

class UserRequirement < ApplicationRecord
  include UserNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :requirement, presence: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :requirement
end
