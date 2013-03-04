class Directive < ActiveRecord::Base
  validates :number, :presence => true
  validates :name, :presence => true, :length => {:minimum => 10}
  validates :body, :length => {:minimum => 2, :maximum => 100}	# орган, утвердивший документ

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :document, :through => :document_directive
  has_many :document_directive, :dependent => :destroy

  def shortname
    return title + " " + number + " " + approval.strftime("%d.%m.%Y")
  end

  def self.search(search)
    if search
      where('number LIKE ? or name LIKE ? or title LIKE ? or body LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
