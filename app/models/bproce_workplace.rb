class BproceWorkplace < ActiveRecord::Base
  validates :bproce_id, :presence => true
  validates :workplace_id, :presence => true
  belongs_to :bproce
  belongs_to :workplace
end
