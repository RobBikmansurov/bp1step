# frozen_string_literal: true

class Task < ActiveRecord::Base
  validates :name, presence: true,
                   length: { minimum: 5, maximum: 255 }
  validates :description, presence: true
  validates :duedate, presence: true

  belongs_to :letter, optional: true
  belongs_to :requirement, optional: true
  belongs_to :author, class_name: 'User'
  has_many :user, through: :user_task
  has_many :user_task, dependent: :destroy # ответственные

  scope :status, ->(status) { where status: status }
  scope :unfinished, -> { where('tasks.status < 90') } # незавершенные
  scope :overdue, -> { unfinished.where('duedate <= ?', Date.current) } # не исполненные в срок
  scope :soon_deadline, -> { unfinished.where('duedate > ?', Date.current - 5.days) } # с наступающим сроком исполнения
  scope :not_assigned, -> { where('status < 5 and author_id IS NOT NULL') } # не назначенные, нет исполнителя

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
    self.author = User.find_by(displayname: name) if name.present?
  end

  def action
    ''
  end

  def action=(action)
    self.result += action if action.present?
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('name ILIKE ? or description ILIKE ? or id = ?', "%#{search}%", "%#{search}%", search.to_i.to_s)
  end

  private

  def check_status
    if user_task.first # если есть исполнители
      self.status = 5 if status < 1 # Назначено, если есть исполнители
    elsif status < 90
      self.status = 0 # Новое, т.к. нет исполнителей и не завершено
    end
    return unless status >= 90 # завершено
    return unless status_was
    self.completion_date = Time.current if status_was < 90 # запомним дату и время завершения, если новый статус - "Завершено"
  end
end
