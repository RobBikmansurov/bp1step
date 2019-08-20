# frozen_string_literal: true

module Authors
  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by(displayname: name) if name.present?
  end
end
