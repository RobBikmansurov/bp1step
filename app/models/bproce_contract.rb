class BproceContract < ActiveRecord::Base
  belongs_to :bproce
  belongs_to :contract

  validates :bproce_id, :presence => true
  validates :contract_id, :presence => true

  attr_accessible :bproce_id, :contract_id, :purpose, :bproce_name

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by_name(name).id if name.present?
  end

end
