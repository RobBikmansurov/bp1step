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

  attr_accessible :label, :date, :source, :duedate, :body, :status, :result, :author_name, :letter_id

  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by_displayname(name) if name.present?
  end

  def self.search(search)
    if search
      where('label ILIKE ? or source ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

end
