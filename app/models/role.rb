class Role < ActiveRecord::Base
  def self.search(search, page)
    paginate :per_page => 10, :page => page,
           :conditions => ['name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%"],
           :order => 'name'
  end

end
