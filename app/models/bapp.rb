class Bapp < ActiveRecord::Base
  validates :name,  :presence => true, 
                    :length => {:minimum => 8, :maximum => 50}

  has_many :bproces
  has_many :workplaces
end
