class UserTask < ActiveRecord::Base
  validates :task, :presence => true
  validates :user, :presence => true

  belongs_to :user
  belongs_to :task

  attr_accessible :user_id, :task_id, :status, :review_date, :user_name, :status_boolean
  attr_reader :responsible
  attr_accessor :status_boolean

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    if name.present?
      user = User.find_by_displayname(name)
      self.user_id = user.id if user
    end
  end

  def responsible? # ответственный исполнитель, если задан статус, отличный от 0
    (status.nil? || status == 0 ? false : true)
  end

end
