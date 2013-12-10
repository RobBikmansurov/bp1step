class BproceDocument < ActiveRecord::Base
  belongs_to :bproce
  belongs_to :document
  
  validates :bproce_id, :presence => true
  validates :document_id, :presence => true

  attr_accessible :bproce_id, :document_id, :purpose
  
end
