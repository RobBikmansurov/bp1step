class BProc < ActiveRecord::Base
  validates :ptitle, :presence => true, 
                     :length => { :minimum => 5 }
  validates :pbody, :presence => true,
                    :length => { :minimum => 10 }
  validates :pcode, :presence => true

  has_many :roles
end
