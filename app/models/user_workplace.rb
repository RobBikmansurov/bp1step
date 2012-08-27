class UserWorkplace < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :workplace_id, :presence => true

  belongs_to :user
  belongs_to :workplace
end
