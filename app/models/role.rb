class Role < ActiveRecord::Base
  validates :name, :uniqueness => true,
  			:presence => true, :length => {:minimum => 4}
  validates :description, :presence => true

  has_many :user_roles
  has_many :users, :through => :user_roles
end
