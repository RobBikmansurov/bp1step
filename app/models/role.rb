class Role < ActiveRecord::Base
  validates :name,  :presence => true, 
                    :length => {:minimum => 8, :maximum => 50}
  def self.search(search, page)
    paginate :per_page => 10, :page => page,
           :conditions => ['name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%"],
           :order => 'name'
  end

end
