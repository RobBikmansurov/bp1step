class Role < ActiveRecord::Base
  validates :name, :presence => true, 
                   :length => { :minimum => 5 }

  belongs_to :b_proc
end
