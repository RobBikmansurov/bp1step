# frozen_string_literal: true

module Users
  def time_and_current_user(text)
    "\r\n" + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ": #{current_user.displayname} #{text}"
  end
end
