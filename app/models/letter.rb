# frozen_string_literal: true

class Letter < ApplicationRecord
  # acts_as_taggable
  # acts_as_nested_set
  include Statuses
  include Actions
  include Authors

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

  scope :status, ->(status) { where status: status }
  scope :overdue, -> { where('duedate <= ? and status < 90', Date.current) } # не исполненные в срок письма
  scope :soon_deadline, -> { where('duedate > ? and status < 90', Date.current - 5.days) } # с наступающим сроком исполнения
  scope :not_assigned, -> { where('status < 5 and author_id IS NOT NULL') } # не назначенные, нет исполнителя

  belongs_to :letter, optional: true
  belongs_to :author, class_name: 'User', optional: true
  has_many :user_letter, dependent: :destroy # ответственные за письмо
  has_many :users, through: :user_letter
  has_many :letter_appendix, dependent: :destroy

  # attr_accessible :number, :date, :regnumber, :regdate, :subject, :source, :sender,
  #                :duedate, :body, :status, :status_name, :result, :author_id, :author_name,
  #                :action, :completion_date, :in_out, :letter_id, :author

  before_save :check_status, :check_regdate

  def status_name
    LETTER_STATUS.key(status)
  end

  def status_name=(key)
    self.status = LETTER_STATUS[key]
  end

  def name
    "№#{number} от #{date.strftime('%d.%m.%y')}"
  end

  def identify
    "#{in_out == 1 ? 'Вх.' : 'Исх.'}№ #{number} от #{date.strftime('%d.%m.%Y')} (##{id})"
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('number ILIKE ? or regnumber ILIKE ? or subject ILIKE ? or sender ILIKE ? or id = ?',
          "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", search.to_i.to_s)
  end

  private

  def check_status
    if user_letter.first # если есть исполнители
      self.status = 5 if status < 1 # Назначено, если есть исполнители
    elsif status < 90
      self.status = 0 # Новое, т.к. нет исполнителей и не завершено
    end
    return unless status >= 90 # завершено

    # дата исполения, если стал - "Завершено"
    self.completion_date = Date.current.strftime('%d.%m.%Y') if status_was.blank? || status_was < 90
  end

  def check_regdate
    return if regnumber.blank?

    self.regdate = Date.current.strftime('%d.%m.%Y') if regdate.blank?
  end
end
