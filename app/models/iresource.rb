class Iresource < ActiveRecord::Base
  validates :label, :presence => true,
                    :uniqueness => true,
                    :length => {:minimum => 3, :maximum => 20}
  validates :location, :presence => true,
                    :length => {:minimum => 3, :maximum => 255}

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  belongs_to :user
  has_many :bproce_iresources
  has_many :bproces, :through => :bproce_iresources

  attr_accessible :label, :location, :level, :alocation, :volume, :note, :access_read, :access_write, :access_other, :risk_category, :owner_name


  def owner_name
    user.try(:displayname)
  end

  def owner_name=(name)
    self.user = User.find_by_displayname(name) if name.present?
  end

  def self.search(search)
    if search
      where('label ILIKE ? or location ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

end
