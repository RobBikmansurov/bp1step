# frozen_string_literal: true

module UserNames
  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by(displayname: name).id if name.present?
  end
end
