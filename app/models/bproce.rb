class Bproce < ActiveRecord::Base
  acts_as_nested_set
  has_many :documents
  has_many :roles
  has_many :bproce_bapps, :dependent => :destroy
  has_many :bapps, :through => :bproce_bapps
  has_and_belongs_to_many :workplaces
  

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
