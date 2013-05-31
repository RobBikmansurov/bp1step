class Bapp < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :name, :presence => true,
            :uniqueness => true,
            :length => {:minimum => 4, :maximum => 50}
  validates :description, :presence => true

  has_many :bproce_bapps
  has_many :bproces, :through => :bproce_bapps
  accepts_nested_attributes_for :bproce_bapps, :allow_destroy => true
  accepts_nested_attributes_for :bproces
  #has_many :workplaces

  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search}")
    else
      scoped
    end
  end

  def self.searchtype(search)
    if search
      where('apptype LIKE ? COLLATE NOCASE', "%#{search}%")
    else
      scoped
    end
  end

end
