class BproceIresource < ActiveRecord::Base
  validates :bproce_id, :presence => true
  validates :iresource_id, :presence => true

  belongs_to :bproce
  belongs_to :iresource
  # attr_accessible :title, :body
end
