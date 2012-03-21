class Bapp < ActiveRecord::Base
  validates :name, :uniqueness => true,
            :length => {:minimum => 8, :maximum => 50}
  validates :description, :presence => true

  has_many :bproce_bapps
  has_many :bproces, :through => :bproce_bapps
  accepts_nested_attributes_for :bproce_bapps, :allow_destroy => true 
  accepts_nested_attributes_for :bproces
  has_many :workplaces

  def self.search(search)
   if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
end
