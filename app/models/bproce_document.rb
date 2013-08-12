class BproceDocument < ActiveRecord::Base
  belongs_to :bproce
  belongs_to :document
  #attr_accessible :purpose
end
