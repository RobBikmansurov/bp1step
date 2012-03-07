class Bproce < ActiveRecord::Base
  has_many :documents
  has_many :roles
  has_many :bapps

  validates :shortname, :uniqueness => true,
                        :length => {:minimum => 3, :maximum => 50}
  validates :name, :uniqueness => true,
                   :length => {:minimum => 10, :maximum => 250}
  validates :fullname, :length => {:minimum => 10, :maximum => 250}

  def self.search(search)
    if search
      where('shortname LIKE ? or name LIKE ? or fullname LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
