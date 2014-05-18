class Contract < ActiveRecord::Base
  validates :number, :presence => true,
                   :length => {:minimum => 1, :maximum => 20}
  validates :name, :presence => true,
                   :length => {:minimum => 3, :maximum => 50}
  validates :description, :presence => true,
                          :length => {:minimum => 8, :maximum => 255}
  validates :status, :presence => true,
                          :length => {:minimum => 5, :maximum => 15}

  belongs_to :owner_id
  belongs_to :user
  belongs_to :owner, :class_name => 'User'
  has_many :bproce, through: :bproce_contract
  has_many :bproce_contract, dependent: :destroy 

  attr_accessible  :owner_name, :number, :name, :status, :date_begin, :date_end, :description, :text, :note


  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  def owner_name
    owner.try(:displayname)
  end

  def owner_name=(name)
    self.owner = User.find_by_displayname(name) if name.present?
  end

  def shortname
    return '№ ' + number.to_s + ' ' + name.split(//u)[0..50].join
  end

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end


end
