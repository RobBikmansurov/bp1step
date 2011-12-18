class Document < ActiveRecord::Base
  belongs_to :bproce

  def self.search(search, page)
    paginate :per_page => 5, :page => page,
           :conditions => ['name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%"],
           :order => 'name'
  end

end
