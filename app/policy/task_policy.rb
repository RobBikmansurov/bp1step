# frozen_string_literal: true

# policy for tasks actions
class TaskPolicy
  def initialize; end

  def allowed_task?(user, task)
    UserTask.where(user_id: user, task_id: task).any? || Task.find(task).author == user
  end

  def allowed?(user, user_id_in_params)
    (user.id == user_id_in_params) || (user.role? :user)
  end
end
