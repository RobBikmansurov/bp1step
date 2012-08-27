class UserRole < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :role_id, :presence => true
  belongs_to :user
  belongs_to :role
end
