class BproceWorkplace < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :bproce_id, :presence => true
  validates :workplace_id, :presence => true

  belongs_to :bproce
  belongs_to :workplace
end
