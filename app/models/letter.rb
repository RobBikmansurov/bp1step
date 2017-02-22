# frozen_string_literal: true
class Letter < ActiveRecord::Base
  # acts_as_taggable
  # acts_as_nested_set

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :subject, presence: true,
                      length: { minimum: 3, maximum: 200 }
  validates :number, presence: true,
                     length: { maximum: 30 },
                     if: -> { in_out != 2 }
  validates :source, length: { maximum: 20 }
  validates :sender, presence: true,
                     length: { minimum: 3 }
  validates :date, presence: true

  scope :status, -> (status) { where status: status }
  scope :overdue, -> { where('duedate <= ? and status < 90', Date.current) } # не исполненные в срок письма
  scope :soon_deadline, -> { where('duedate > ? and status < 90', Date.current - 5.days) } # с наступающим сроком исполнения
  scope :not_assigned, -> { where('status < 5 and author_id IS NOT NULL') } # не назначенные, нет исполнителя

  belongs_to :letter
  belongs_to :author, class_name: 'User'
  has_many :user_letter, dependent: :destroy # ответственные за письмо
  has_many :users, through: :user_letter
  has_many :letter_appendix, dependent: :destroy

  attr_accessible :number, :date, :regnumber, :regdate, :subject, :source, :sender,
                  :duedate, :body, :status, :status_name, :result, :author_id, :author_name,
                  :action, :completion_date, :in_out, :letter_id, :author

  before_save :check_status, :check_regdate

  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by(displayname: name) if name.present?
  end

  def status_name
    LETTER_STATUS.key(status)
  end

  def status_name=(key)
    self.status = LETTER_STATUS[key]
  end

  def action
    ''
  end

  def action=(action)
    self.result += action unless action.blank?
  end

  def name
    "№#{number} от #{date.strftime('%d.%m.%y')}"
  end

  def self.search(search)
    if search
      where('number ILIKE ? or regnumber ILIKE ? or subject ILIKE ? or sender ILIKE ? or id = ?',
            "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", search.to_i.to_s)
    else
      where(nil)
    end
  end

  private

  def check_status
    if user_letter.first # если есть исполнители
      self.status = 5 if status < 1 # Назначено, если есть исполнители
    else
      self.status = 0 if status < 90 # Новое, т.к. нет исполнителей и не завершено
    end
    return unless status >= 90 # завершено
    self.completion_date = Date.current.strftime('%d.%m.%Y') if status_was < 90 # дата исполения, если стал - "Завершено"
  end

  def check_regdate
    return if regnumber.blank?
    self.regdate = Date.current.strftime('%d.%m.%Y') if regdate.blank?
  end
end
