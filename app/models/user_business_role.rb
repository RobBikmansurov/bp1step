class UserBusinessRole < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :business_role_id, :presence => true
  belongs_to :user
  belongs_to :business_role

  def user_name
    user.try(:displayname)
  end
  def user_name=(name)
    self.user_id = User.find_by_displayname(name).id if name.present?
  end
  
end
