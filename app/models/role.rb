class Role < ActiveRecord::Base
  validates :description, :presence => true
  validates :name, :presence => true, :length => {:minimum => 5}

  has_many :user_roles
  has_many :user, :through => :user_roles
end
