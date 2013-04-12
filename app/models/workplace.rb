class Workplace < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :designation, :presence => true,
                          :uniqueness => true,
                          :length => {:minimum => 8, :maximum => 50}

  has_many :bproce_workplaces
  has_many :bproces, :through => :bproce_workplaces
  has_many :user_workplace    # пользователи рабочего миеста
  has_many :users, :through => :user_workplace, :dependent => :destroy

  accepts_nested_attributes_for :bproce_workplaces, :allow_destroy => true
  accepts_nested_attributes_for :bproces
  #has_many :bapps

  def self.search(search)
    if search
      where('designation LIKE ? or name LIKE ? or description LIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
