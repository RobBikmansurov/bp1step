class Directive < ActiveRecord::Base
  validates :number, :presence => true
  validates :name, :presence => true, :length => {:minimum => 10}
  validates :body, :length => {:minimum => 4, :maximum => 100}	# орган, утвердивший документ

  has_many :document, :through => :document_directive
  has_many :document_directive, :dependent => :destroy

  def shortname
    return title + " " + number + " " + approval.to_s
  end

  def self.search(search)
    if search
      where('number LIKE ? or name LIKE ? or title LIKE ? or body LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
