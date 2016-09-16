# encoding: utf-8
class Contract < ActiveRecord::Base
  acts_as_taggable
  acts_as_nested_set

  scope :active, -> { where.not(status: 'НеДействует') } # действующие договоры


  validates :number, :presence => true,
                   :length => {:minimum => 1, :maximum => 20}
  validates :name, :presence => true,
                   :length => {:minimum => 3, :maximum => 255}
  validates :description, :presence => true,
                          :length => {:minimum => 8, :maximum => 255}
  validates :status, :presence => true,
                          :length => {:minimum => 5, :maximum => 15}
  validates :contract_type, :presence => true,
                          :length => {:minimum => 5, :maximum => 30}
  validates :contract_place, :length => {:maximum => 30}
  #validates :owner_id, presence: :true

  #belongs_to :contract, foreign_key: "parent_id"  # родительский договор
  #belongs_to :user
  belongs_to :agent
  belongs_to :owner, :class_name => 'User'
  belongs_to :payer, :class_name => 'User'
  belongs_to :parent, :class_name => 'Contract'
  belongs_to :contract

  has_many :bproce, through: :bproce_contract
  has_many :bproce_contract, dependent: :destroy
  has_many :contract_scan, dependent: :destroy
  #has_many :children, :class => 'Contract', foreign_key: :parent_id

  attr_accessible  :owner_name, :owner_id, :payer_name, :payer_id, :agent_name, :agent_id, :number, :name, :status, :date_begin, :date_end, :description, :text, :note, :condition, :check, :parent_id, :parent_name, :contract_type, :contract_place


  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  def agent_name    # Контрагент
    agent.try(:name)
  end

  def agent_name=(name)
    self.agent = Agent.find_by_name(name) if name.present?
  end

  def owner_name    # ответственный за договор
    owner.try(:displayname)
  end

  def owner_name=(name)
    self.owner = User.find_by_displayname(name) if name.present?
  end

  def payer_name    # ответственный за оплату договора
    payer.try(:displayname)
  end

  def payer_name=(name)
    self.payer = User.find_by_displayname(name) if name.present?
  end

  def parent_name
    parent.try(:autoname)
  end

  def parent_name=(name)
    id_find = name[/#.*\ №/]
    if id_find
      id_find = id_find[1..-3] # выделим #id
      parent_find = Contract.where(:id => id_find) if id_find
      self.parent = parent_find.first if parent_find
    end
  end

  def shortname
    return '№ ' + number.to_s + ' ' + name.split(//u)[0..50].join
  end

  def autoname
    return '#' + id.to_s + ' №' + number.to_s + ' | ' + name.split(//u)[0..50].join
  end

  def self.search(search)
    if search
      where('name ILIKE ? or number ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

end
