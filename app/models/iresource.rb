class Iresource < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  validates :label, :uniqueness => true,
                    :length => {:minimum => 3, :maximum => 20}
  validates :location, :length => {:minimum => 3, :maximum => 255}

  belongs_to :user
  has_many :bproce_iresources
  has_many :bproces, :through => :bproce_iresources

  def owner_name
    user.try(:displayname)
  end
  def owner_name=(name)
    self.user = User.find_by_displayname(name) if name.present?
  end

  def self.search(search)
   if search
      where('label LIKE ? or location LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
