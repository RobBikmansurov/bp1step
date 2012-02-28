class Role < ActiveRecord::Base
  validates :name, :length => {:minimum => 8, :maximum => 50}
  validates :description, :length => {:minimum => 8}
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
