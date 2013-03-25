class BproceIresource < ActiveRecord::Base
  belongs_to :bproce
  belongs_to :iresource
  # attr_accessible :title, :body
end
