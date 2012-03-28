class BproceBapp < ActiveRecord::Base
  validates :bproce_id, :presence => true
  validates :bapp_id, :presence => true
  belongs_to :bproce
  belongs_to :bapp
end
