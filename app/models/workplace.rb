class Workplace < ActiveRecord::Base
  validates :designation, :uniqueness => true,
                          :length => {:minimum => 8, :maximum => 50}

  has_many :bproce_workplaces
  has_many :bproces, :through => :bproce_workplaces
  accepts_nested_attributes_for :bproce_workplaces, :allow_destroy => true 
  #has_many :bapps

  def self.search(search)
   if search
      where('designation LIKE ? or name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
