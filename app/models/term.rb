class Term < ActiveRecord::Base
  validates :shortname, :uniqueness => true,
                    	:length => {:maximum => 20}
  validates :name, :presence => true, 
                    :length => {:minimum => 3, :maximum => 200}
  validates :description, :presence => true

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  def self.search(search)
    if search
      where('shortname LIKE ? or name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end
end
