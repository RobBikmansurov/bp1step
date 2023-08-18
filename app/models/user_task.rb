# frozen_string_literal: true

class UserTask < ApplicationRecord
  include UserNames

  validates :task, presence: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :task

  scope :user, ->(user) { where(user_id: user) }
  scope :unviewed, -> { where(review_date: nil).joins(:task).merge(Task.unfinished) }

  # attr_accessible :user_id, :task_id, :status, :review_date, :user_name, :status_boolean
  attr_reader :responsible
  attr_accessor :status_boolean

  # ответственный исполнитель, если задан статус, отличный от 0
  def responsible?
    !(status.nil? || status.zero?)
  end
end
