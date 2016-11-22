class Requirement < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :label, :presence => true,
                   :length => {:minimum => 3, :maximum => 255}

  belongs_to :letter
  #belongs_to :user
  belongs_to :author, :class_name => 'User'
  has_many :user, through: :user_requirement
  has_many :user_requirement, dependent: :destroy # ответственные за Требование
  has_many :task

  attr_accessible :label, :date, :source, :duedate, :body, :status, :status_name, :result,
                  :author_name, :author, :letter_id

  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by_displayname(name) if name.present?
  end

  def status_name
    REQUIREMENT_STATUS.key(status)
  end
  
  def status_name=(key)
    self.status = REQUIREMENT_STATUS[key]
  end

  def name
    return "[#{label}] от #{date.strftime("%d.%m.%y")}"
  end

  def self.search(search)
    if search
      where('label ILIKE ? or source ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

end
