# frozen_string_literal: true

module OwnerNames
  def owner_name
    owner.try(:displayname)
  end

  def owner_name=(name)
    self.owner = User.find_by(displayname: name) if name.present?
  end
end
