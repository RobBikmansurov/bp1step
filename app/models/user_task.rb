class UserTask < ActiveRecord::Base
  validates :task, :presence => true
  validates :user, :presence => true

  belongs_to :user
  belongs_to :task

  attr_accessible :user_id, :task_id, :status, :review_date, :user_name

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by_displayname(name).id if name.present?
  end

end
