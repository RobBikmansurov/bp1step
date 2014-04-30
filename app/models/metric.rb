class Metric < ActiveRecord::Base
  validates :name, :presence => true,
                   :length => {:minimum => 5, :maximum => 50}
  validates :description, :presence => true,
                          :length => {:minimum => 8, :maximum => 255}
  validates :bproce_id, :presence => true

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  attr_accessible :bproce_id, :name, :shortname, :description, :note, :depth
  
  belongs_to :bproce 	# метика относится к процессу

  self.per_page = 10

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

end
