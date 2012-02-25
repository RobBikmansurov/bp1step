class Bproce < ActiveRecord::Base

  has_many :documents
  has_many :roles
  has_many :bapps
  validates :shortname,  :presence => true,
                    :length => {:minimum => 4, :maximum => 50}
  validates :name,  :presence => true,
                    :length => {:minimum => 10, :maximum => 250}
  validates :fullname,  :presence => true,
                    :length => {:minimum => 10, :maximum => 250}
  def self.search(search)
   if search
      where('shortname LIKE ? or name LIKE ? or fullname LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
