class UserBusinessRole < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :business_role_id, :presence => true
  belongs_to :user
  belongs_to :business_role
end
