class Term < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :shortname, :uniqueness => true,
                    	:length => {:maximum => 20}
  validates :name, :presence => true, 
                    :length => {:minimum => 3, :maximum => 200}
  validates :description, :presence => true

  attr_accessible :name, :shortname, :description

  def self.search(search)
    if search
      where('shortname ILIKE ? or name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end
end
