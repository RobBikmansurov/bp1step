class Bproce < ActiveRecord::Base
  validates :shortname, :uniqueness => true,
                        :length => {:minimum => 1, :maximum => 50}
  validates :name, :uniqueness => true,
                   :length => {:minimum => 10, :maximum => 250}
  validates :fullname, :length => {:minimum => 10, :maximum => 250}

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  acts_as_nested_set
  has_many :documents
  has_many :business_roles
  has_many :bproce_bapps, :dependent => :destroy
  has_many :bapps, :through => :bproce_bapps
  has_many :bproce_workplaces, :dependent => :destroy
  has_many :workplaces, :through => :bproce_workplaces
  belongs_to :bproce
  belongs_to :user #, :class_name => "User"
  #accepts_nested_attributes_for :business_roles
  #has_and_belongs_to_many :workplaces
  
  def self.search(search)
    if search
      where('shortname LIKE ? or name LIKE ? or fullname LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
