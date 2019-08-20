# frozen_string_literal: true

class BproceIresource < ApplicationRecord
  include BproceNames

  validates :bproce_id, presence: true
  validates :iresource_id, presence: true

  belongs_to :bproce
  belongs_to :iresource

  # attr_accessible :bproce_id, :iresource_id, :rpurpose, :iresource_label, :bproce_name

  def iresource_label
    iresource.try(:label)
  end

  def iresource_label=(name)
    self.iresource_id = Iresource.find_by(label: name).id if name.present?
  end
end
