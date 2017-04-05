# frozen_string_literal: true

class UserWorkplace < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  attr_accessible :workplace_id

  validates :user_id, presence: true
  validates :workplace_id, presence: true

  belongs_to :user
  belongs_to :workplace

  attr_accessible :user_name, :date_from, :date_to, :note

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by(displayname: name).id if name.present?
  end
end
