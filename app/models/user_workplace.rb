class UserWorkplace < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  attr_accessible :workplace_id

  validates :user_id, :presence => true
  validates :workplace_id, :presence => true

  belongs_to :user
  belongs_to :workplace

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by_displayname(name).id if name.present?
  end


end
