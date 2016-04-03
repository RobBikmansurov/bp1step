class UserRole < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :role, :presence => true
  validates :user, :presence => true

  belongs_to :role
  belongs_to :user
end