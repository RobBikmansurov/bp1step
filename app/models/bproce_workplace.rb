class BproceWorkplace < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :bproce_id, :presence => true
  validates :workplace_id, :presence => true

  belongs_to :bproce
  belongs_to :workplace

  attr_accessible :workplace_id, :bproce_id

  def workplace_designation
    workplace.try(:designation)
  end

  def workplace_designation=(name)
    self.workplace_id = Workplace.find_by_designation(name).id if name.present?
  end


end
