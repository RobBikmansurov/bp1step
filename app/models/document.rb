class Document < ActiveRecord::Base
  validates :name, :presence => true, 
                   :length => {:minimum => 10, :maximum => 254}
  belongs_to :bproce

  def self.search(search, page)
    paginate :per_page => 5, :page => page,
           :conditions => ['name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%"],
           :order => 'part, name'
  end

end
