class Bapp < ActiveRecord::Base
  validates :name,  :presence => true, 
                    :length => {:minimum => 8, :maximum => 50}

  has_many :bproces
  has_many :workplaces

  def self.search(search)
   if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
end
