class UserDocument < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :user_id, presence: true
  validates :document_id, presence: true

  belongs_to :user
  belongs_to :document

  attr_accessible :user_id, :document_id, :link

end
