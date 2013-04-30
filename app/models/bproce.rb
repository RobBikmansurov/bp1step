class Bproce < ActiveRecord::Base
  include TheSortableTree::Scopes
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }


  validates :shortname, :presence => true,
                        :uniqueness => true,
                        :length => {:minimum => 1, :maximum => 50}
  validates :name, :presence => true,
                   :uniqueness => true,
                   :length => {:minimum => 10, :maximum => 250}
  validates :fullname, :length => {:minimum => 10, :maximum => 250}

  acts_as_nested_set
  has_many :documents
  has_many :business_roles, :dependent => :destroy
  has_many :bproce_bapps, :dependent => :destroy
  has_many :bapps, :through => :bproce_bapps, :dependent => :destroy
  has_many :bproce_workplaces, :dependent => :destroy
  has_many :workplaces, :through => :bproce_workplaces
  has_many :bproce_iresource, :dependent => :destroy
  has_many :iresource, :through => :bproce_iresource
  belongs_to :bproce
  belongs_to :user  # владелец процессв

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by_displayname(name).id if name.present?
  end

  def self.search(search)
    if search
      where('shortname LIKE ? or name LIKE ? or fullname LIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

end
