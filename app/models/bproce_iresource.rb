class BproceIresource < ActiveRecord::Base
  validates :bproce_id, :presence => true
  validates :iresource_id, :presence => true

  belongs_to :bproce
  belongs_to :iresource

  attr_accessible :bproce_id, :iresource_id, :rpurpose, :iresource_label, :bproce_name

  def bproce_name
    bproce.try(:name)
  end

  def bproce_name=(name)
    self.bproce_id = Bproce.find_by_name(name).id if name.present?
  end

  def iresource_label
    iresource.try(:label)
  end

  def iresource_label=(name)
    self.iresource_id = Iresource.find_by_label(name).id if name.present?
  end

end
