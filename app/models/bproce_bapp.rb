class BproceBapp < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :bproce_id, :presence => true
  validates :bapp_id, :presence => true
  validates :apurpose, :presence => true

  belongs_to :bproce
  belongs_to :bapp

  def bapp_name
    bapp.try(:designation)
  end

  def bapp_name=(name)
    self.bapp_id = Bapp.find_by_name(name).id if name.present?
  end

  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
