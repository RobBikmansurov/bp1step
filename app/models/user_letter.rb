class UserLetter < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :letter, :presence => true
  validates :user, :presence => true

  belongs_to :user
  belongs_to :letter

  attr_accessible :user_id, :letter_id, :status, :user_name

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by_displayname(name).id if name.present?
  end

end
