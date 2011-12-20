class Workplace < ActiveRecord::Base
  validates :designation, :length => {:minimum => 8, :maximum => 50}
  has_many :bapps
  def self.search(search, page)
    paginate :per_page => 10, :page => page,
           :conditions => ['designation LIKE ? or name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"],
           :order => 'designation, name'
  end

end
