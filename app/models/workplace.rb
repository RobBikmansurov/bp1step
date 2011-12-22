class Workplace < ActiveRecord::Base
  validates :designation, :length => {:minimum => 8, :maximum => 50}
  has_many :bapps
  def self.search(search)
   if search
      where('designation LIKE ? or name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
