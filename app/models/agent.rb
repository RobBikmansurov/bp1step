class Agent < ActiveRecord::Base

  has_many :contract, through: :agent_contract
  has_many :agent_contract, dependent: :destroy 

  validates :name, :presence => true,
                   :length => {:minimum => 3, :maximum => 255}

  attr_accessible  :name, :town, :address, :contacts, :agent_name


  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  def self.search(search)
    if search
      where('name ILIKE ? or number ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

end
