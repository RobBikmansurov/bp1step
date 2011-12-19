class Workplace < ActiveRecord::Base
  has_many :bapps
  def self.search(search, page)
    paginate :per_page => 10, :page => page,
           :conditions => ['designation LIKE ? or name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"],
           :order => 'designation, name'
  end

end
