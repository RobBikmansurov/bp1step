class Role < ActiveRecord::Base
  validates :name, :presence => true,
                   :length => {:minimum => 5, :maximum => 50}
  validates :description, :presence => true,
                          :length => {:minimum => 8}
  validates :bproce_id, :presence => true

  # роль участвует в процессе
  belongs_to :bproce
  # роль может исполняться многими пользователями
  has_many :user_role  # пользователь может иметь много ролей
  has_many :users, :through => :user_role

  # роль может исполняется на нескольких рабочих местах
  #has_and_belongs_to_many :workplaces


  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
