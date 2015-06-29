class Letter < ActiveRecord::Base
  #acts_as_taggable
  #acts_as_nested_set

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :subject, :presence => true,
                   :length => {:minimum => 3, :maximum => 200}

  belongs_to :letter
  has_many :user_letter, :dependent => :destroy  # ответственные за письмо
  has_many :users, :through => :user_letter
  has_many :letter_appendix, dependent: :destroy

  attr_accessible :number, :date, :subject, :source, :sender, :duedate, :body, :status, :result

  def self.search(search)
    if search
      where('number ILIKE ? or regnumber ILIKE ? or subject ILIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      where(nil)
    end
  end
end
