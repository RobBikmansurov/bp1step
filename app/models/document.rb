class Document < ActiveRecord::Base
  validates :name, :length => {:minimum => 10, :maximum => 200}
  validates :bproce_id, :presence => true
  belongs_to :category
  # документ относится к процессу
  belongs_to :bproce

  attr_accessor :new_category_name
  before_save :create_category_from_name

  def create_category_from_name
    create_category(:cat_name => new_category_name) unless new_category_name.blank?
  end

  def self.search(search)
    if search  
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else  
      scoped
    end  
  end
end
