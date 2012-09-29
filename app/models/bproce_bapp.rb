class BproceBapp < ActiveRecord::Base
  validates :bproce_id, :presence => true
  validates :bapp_id, :presence => true
  validates :apurpose, :presence => true
  belongs_to :bproce
  belongs_to :bapp

  def self.search(search)
   if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
