# frozen_string_literal: true

class UserRequirement < ApplicationRecord
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :requirement, presence: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :requirement

  # attr_accessible :user_id, :requirement_id, :status, :user_name

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by(displayname: name).id if name.present?
  end
end
