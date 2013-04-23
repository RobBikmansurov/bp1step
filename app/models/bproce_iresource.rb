class BproceIresource < ActiveRecord::Base
  validates :bproce_id, :presence => true
  validates :iresource_id, :presence => true

  belongs_to :bproce
  belongs_to :iresource
  # attr_accessible :title, :body

  def iresource_label
    iresource.try(:label)
  end

  def iresource_label=(name)
    self.iresource_id = Iresource.find_by_label(name).id if name.present?
  end

end
