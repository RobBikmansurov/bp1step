class Document < ActiveRecord::Base
  validates :name, :presence => true, 
                   :length => {:minimum => 10, :maximum => 254}
  belongs_to :bproce
  belongs_to :category
  attr_accessor :new_category_name
  before_save :create_category_from_name

  def create_category_from_name
    create_category(:name => new_category_name) unless new_category_name.blank?
  end

  def self.search(search)
    if search  
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else  
      scoped
    end  
  end

end
