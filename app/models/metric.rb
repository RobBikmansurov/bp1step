class Metric < ActiveRecord::Base
  validates :name, :presence => true,
                   :length => {:minimum => 5, :maximum => 50}
  validates :description, :presence => true,
                          :length => {:minimum => 8, :maximum => 255}
  validates :bproce_id, :presence => true
  validates :mtype, :length => {:maximum => 10}
  validates :mhash, :length => {:maximum => 32}

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  attr_accessible :bproce_id, :name, :shortname, :description, :note, :depth,  :depth_name, :bproce_name, :mtype, :msql, :mhash
  
  belongs_to :bproce 	# метика относится к процессу

  self.per_page = 10

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by_name(name).id if name.present?
  end

  def depth_name
    METRICS_VALUE_DEPTH.key(depth)
  end
  
  def depth_name=(key)
    self.depth = METRICS_VALUE_DEPTH[key]
  end

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

end
