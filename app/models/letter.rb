class Letter < ActiveRecord::Base
  #acts_as_taggable
  #acts_as_nested_set

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :subject, :presence => true,
                   :length => {:minimum => 3, :maximum => 200}
  validates :number, :length => {:maximum => 20}
  validates :source, :length => {:maximum => 10}

  belongs_to :letter
  belongs_to :author, :class_name => 'User'
  has_many :user_letter, :dependent => :destroy  # ответственные за письмо
  has_many :users, :through => :user_letter
  has_many :letter_appendix, dependent: :destroy

  attr_accessible :number, :date, :subject, :source, :sender, :duedate, :body, :status, :result, :author_id, :author_name

  def author_name
    author.try(:displayname)
  end

  def author_name=(name)
    self.author = User.find_by_displayname(name) if name.present?
  end

  def self.search(search)
    if search
      where('number ILIKE ? or regnumber ILIKE ? or subject ILIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end
end
