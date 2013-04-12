class Role < ActiveRecord::Base
  validates :name, :uniqueness => true,
                   :presence => true, :length => {:minimum => 4}
  validates :description, :presence => true

  has_many :user_roles
  has_many :users, :through => :user_roles

  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
