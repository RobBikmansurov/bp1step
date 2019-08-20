# frozen_string_literal: true

class UserLetter < ApplicationRecord
  include UserNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  default_scope { order('status DESC') }

  validates :letter, presence: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :letter
end
