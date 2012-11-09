class Document < ActiveRecord::Base
  # TODO добавить StateMachine
  # FIXME разобраться со статусами на русском
  # STATUSES = %w[Проект Согласование Утвержден]
  # validates_inclusion_of :status, in: STATUSES
  validates :name, :length => {:minimum => 10, :maximum => 200}
  validates :bproce_id, :presence => true # документ относится к процессу
  validates :dlevel, :numericality => {:less_than => 5, :greater_than => 0}

  # документ относится к процессу
  belongs_to :bproce
  has_many :user, :through => :document_user
  has_many :directive, :through => :document_directive
  has_many :document_directive, :dependent => :destroy

  attr_protected :uploaded_file # чтобы не было ошибки при массовом сохранении из params

  def shortname
    return name.split(//u)[0..50].join
  end

  def self.search(search)
    if search  
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else  
      scoped
    end  
  end
end
