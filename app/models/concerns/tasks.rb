# frozen_string_literal: true

module Tasks
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

  def identify
    "Задача (##{id}) \"#{name}\" от #{created_at.strftime('%d.%m.%Y')}"
  end
end
