class Directive < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :approval, :presence => true
  validates :number, :presence => true
  validates :name, :presence => true, :length => {:minimum => 10}
  validates :body, :length => {:minimum => 2, :maximum => 100}	# орган, утвердивший документ

  has_many :document, :through => :document_directive
  has_many :document_directive, :dependent => :destroy

  attr_accessible :name, :body, :number, :approval, :title, :annotation, :note

  def shortname
    if approval
      return title + ' ' + number + ' от ' + approval.strftime('%d.%m.%Y')
    else
      return title + ' ' + number
    end
  end

  def midname
    if approval
      return title + ' ' + body + ' №' + number + ' ' + approval.strftime('%d.%m.%Y')
    else
      return title + ' ' + body + ' №' + number
    end
  end

  def directive_name
    #self.try(:shortname + '  #' + :id)
    return self.midname + '   #' + id.to_s
  end

  def directive_name=(name)
    if name.present?
      i = name.rindex('#')
      self.directive_id = name.slice(i + 1, 5).to_i if i.to_i > 0
    end
  end

  def self.search(search)
    if search
      where('number ILIKE ? or name ILIKE ? or title ILIKE ? or body ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end

end
