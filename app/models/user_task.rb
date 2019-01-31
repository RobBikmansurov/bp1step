# frozen_string_literal: true

class UserTask < ApplicationRecord
  validates :task, presence: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :task

  scope :user, ->(user) { where('user_id = ?', user) }
  scope :unviewed, -> { where('review_date IS NULL').joins(:task).merge(Task.unfinished) }

  attr_reader :responsible
  attr_accessor :status_boolean

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    return if name.blank?

    user = User.find_by(displayname: name)
    self.user_id = user.id if user
  end

  def responsible?
    !(status.nil? || status.zero?) # ответственный исполнитель, если задан статус, отличный от 0
  end
end
