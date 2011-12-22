class Document < ActiveRecord::Base
  validates :name, :presence => true, 
                   :length => {:minimum => 10, :maximum => 254}
  belongs_to :bproce

  def self.search(search)
    if search  
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else  
      scoped
    end  
  end

end
