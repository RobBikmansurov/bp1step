class Contract < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  belongs_to :owner_id
  belongs_to :user
  belongs_to :owner, :class_name => 'User'
  has_many :bproce, through: :bproce_document
  has_many :bproce_document, dependent: :destroy 

  attr_accessible  :name, :dlevel, :description, :owner_name, :status, :approveorgan, :approved, :note, :place, :document_file, :file_delete



  def shortname
    return name.split(//u)[0..50].join
  end

  def self.search(search)
    if search
      where('name ILIKE ? or description ILIKE ? or id = ?', "%#{search}%", "%#{search}%", "#{search.to_i}")
    else
      where(nil)
    end
  end

end
