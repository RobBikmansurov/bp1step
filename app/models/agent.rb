# Agent
class Agent < ActiveRecord::Base
  attr_accessible :shortname, :name, :town, :address, :contacts, :agent_name, :note
  
  has_many :contract, through: :agent_contract
  has_many :agent_contract, dependent: :destroy

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 255 }
  validates :town, length: { maximum: 30 }

  def self.search(search)
    if search
      where('name ILIKE ? or shortname ILIKE ? or contacts ILIKE ? or id = ?',
            "%#{search}%", "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, _model| controller.current_user }

end
