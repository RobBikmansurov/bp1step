class MetricValue < ActiveRecord::Base
  validates :value, :presence => true

  belongs_to :metric

end
