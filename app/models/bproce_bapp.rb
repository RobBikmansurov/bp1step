class BproceBapp < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :bproce_id, :presence => true
  validates :bapp_id, :presence => true
  validates :apurpose, :presence => true

  belongs_to :bproce
  belongs_to :bapp

  attr_accessible :bproce_id, :bapp_id, :apurpose

  def bapp_name
    bapp.try(:designation)
  end

  def bapp_name=(name)
    self.bapp_id = Bapp.find_by_name(name).id if name.present?
  end

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ?', "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

end
