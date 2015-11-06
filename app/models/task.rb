class Task < ActiveRecord::Base

  validates :name, :presence => true,
                   :length => {:minimum => 5, :maximum => 255}
  validates :description, presence: true
  validates :duedate, presence: true

  belongs_to :letter
  belongs_to :requirement
  belongs_to :author, :class_name => 'User'
  has_many :user, through: :user_task
  has_many :user_task, dependent: :destroy # ответственные

  before_save :check_status

  def status_name
    TASK_STATUS.key(status)
  end
  
  def status_name=(key)
    self.status = TASK_STATUS[key]
  end

  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by_displayname(name) if name.present?
  end

  def action
    ''
  end

  def action=(action)
    self.result += action if !action.blank?
  end

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

  private
    def check_status
      if self.user_task.first  # если есть исполнители
        self.status = 5 if status < 1 # Назначено, если есть исполнители
      else
        self.status = 0  if status < 90  # Новое, т.к. нет исполнителей и не завершено
      end
      if status >= 90 # завершено
        self.completion_date = Date.current.strftime("%d.%m.%Y") if status_was < 90   # запомним дату исполения, если новый статус - "Завершено"
      end
    end


end
