# frozen_string_literal: true

class UserBusinessRole < ApplicationRecord
  include UserNames

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :user_id, presence: true
  validates :business_role_id, presence: true

  belongs_to :user
  belongs_to :business_role
end
