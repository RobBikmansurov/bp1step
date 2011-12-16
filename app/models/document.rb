class Document < ActiveRecord::Base
  belongs_to :bproce
  def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%"])
  else
    find(:all)
  end
end


end
