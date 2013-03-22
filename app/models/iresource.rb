class Iresource < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  validates :label, :uniqueness => true,
                    :length => {:minimum => 3, :maximum => 20}
  validates :location, :length => {:minimum => 3, :maximum => 255}

  belongs_to :users
  attr_accessible :access_other, :access_read, :access_write, :label, :level, :location, :note, :volume

  def self.search(search)
   if search
      where('label LIKE ? or location LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
