class Role < ActiveRecord::Base
  validates :name, :uniqueness => true,
  			:presence => true, :length => {:minimum => 5}
  validates :description, :presence => true

  has_many :user_roles
  has_many :user, :through => :user_roles
end
