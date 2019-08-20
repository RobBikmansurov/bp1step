# frozen_string_literal: true

class Requirement < ApplicationRecord
  include Statuses
  include Authors

  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  scope :status, ->(status) { where status: status }
  scope :unfinished, -> { where('requirements.status < 90') } # незавершенные

  validates :label, presence: true,
                    length: { minimum: 3, maximum: 255 }

  belongs_to :letter, optional: true
  # belongs_to :user
  belongs_to :author, class_name: 'User'
  has_many :user, through: :user_requirement
  has_many :user_requirement, dependent: :destroy # ответственные за Требование
  has_many :task, dependent: :destroy

  # attr_accessible :label, :date, :source, :duedate, :body, :status, :status_name,
  #                :result, :author_name, :author, :letter_id

  def status_name
    REQUIREMENT_STATUS.key(status)
  end

  def status_name=(key)
    self.status = REQUIREMENT_STATUS[key]
  end

  def name
    "[#{label}] от #{date.strftime('%d.%m.%y')}"
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('label ILIKE ? or source ILIKE ?', "%#{search}%", "%#{search}%")
  end

  def tasks_statuses
    tasks_statuses = ''
    task.order(:id).each do |task|
      tasks_statuses += task.status_mark
    end
    tasks_statuses
  end
end
