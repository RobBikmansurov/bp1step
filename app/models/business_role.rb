class BusinessRole < ActiveRecord::Base
  validates :name, :presence => true,
                   :length => {:minimum => 5, :maximum => 50}
  validates :description, :presence => true,
                          :length => {:minimum => 8}
  validates :bproce_id, :presence => true

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  # бизнес-роль участвует в процессе
  belongs_to :bproce
  # бизнес-роль может исполняться многими пользователями
  has_many :user_business_role  # пользователь может иметь много ролей
  has_many :users, :through => :user_business_role

  # бизнес-роль может исполняется на нескольких рабочих местах
  #has_and_belongs_to_many :workplaces


  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
end
