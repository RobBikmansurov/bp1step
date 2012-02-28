class Role < ActiveRecord::Base
  validates :name,  :presence => true, 
                    :length => {:minimum => 8, :maximum => 50}
  validates :bproce_id,  :presence => true
  # роль в процессе
  belongs_to :bproce
  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
