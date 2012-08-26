class UserWorkplace < ActiveRecord::Base
  belongs_to :user
  belongs_to :workplace
end
