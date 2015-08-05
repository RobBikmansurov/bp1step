class Letter < ActiveRecord::Base
  #acts_as_taggable
  #acts_as_nested_set

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :subject, :presence => true,
                   :length => {:minimum => 3, :maximum => 200}
  validates :number, presence: true,
                     length: {:maximum => 20}
  validates :source, :length => {:maximum => 10}
  validates :sender, presence: true,
                     length: {minimum: 3}
  validates :date, presence: true

  scope :overdue, -> { where('duedate <= ? and status < 90', Date.current) }  # не исполненные в срок письма
  scope :not_assigned, -> { where('status < 5 and author_id IS NOT NULL') }   # не назначенные, нет исполнителя

  belongs_to :letter
  belongs_to :author, :class_name => 'User'
  has_many :user_letter, :dependent => :destroy  # ответственные за письмо
  has_many :users, :through => :user_letter
  has_many :letter_appendix, dependent: :destroy

  attr_accessible :number, :date, :subject, :source, :sender, :duedate, :body, :status, :status_name, :result, :author_id, :author_name

  before_save :check_status


  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by_displayname(name) if name.present?
  end

  def status_name
    LETTER_STATUS.key(status)
  end
  
  def status_name=(key)
    self.status = LETTER_STATUS[key]
  end

  def name
    return "№#{number} от #{date.strftime("%d.%m.%y")}"
  end

  def self.search(search)
    if search
      where('number ILIKE ? or regnumber ILIKE ? or subject ILIKE ? or sender ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

  private
    def check_status
      if status < 1   # письмо новое
        self.status = 5 if self.user_letter.first  # Назначено
      end
      self.status = 0 if !self.user_letter.first  # Новое - если никому не назначено
    end
end
