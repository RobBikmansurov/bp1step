class Bproce < ActiveRecord::Base
  include TheSortableTree::Scopes
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  include PgSearch
  pg_search_scope :search__by_all_column, against: [:description, :goal, :id, :name, :fullname, :shortname]

  acts_as_taggable

  validates :shortname, :presence => true,
                        :uniqueness => true,
                        :length => {:minimum => 1, :maximum => 50}
  validates :name, :presence => true,
                   :uniqueness => true,
                   :length => {:minimum => 10, :maximum => 250}
  validates :fullname, :length => {:minimum => 10, :maximum => 250}

  acts_as_nested_set
  attr_accessible :shortname, :name, :fullname, :goal, :description, :user_name, :parent_id, :parent_name, :tag_list, :tag_id, :context, :taggable, :checked_at

  has_many :bapps, :through => :bproce_bapps, :dependent => :destroy
  has_many :bproce_bapps, :dependent => :destroy
  has_many :bproce_documents, dependent: :destroy 
  has_many :bproce_iresource, :dependent => :destroy
  has_many :bproce_workplaces, :dependent => :destroy
  has_many :business_roles, :dependent => :destroy
  has_many :bproce_contract
  has_many :contracts, through: :bproce_contract
  has_many :documents, through: :bproce_documents
  has_many :iresource, :through => :bproce_iresource
  has_many :workplaces, :through => :bproce_workplaces
  has_many :metrics
  belongs_to :bproce, foreign_key: "parent_id"  # родительский процесс
  belongs_to :user    # владелец процессв

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by_displayname(name).id if name.present?
  end

  def parent_name
    bproce.try(:name)
  end

  def parent_name=(name)
    self.parent_id = Bproce.find_by_name(name).id if name.present?
  end

  def bproces_of_directive(directive_id) # процессы директивы (все процессы, связанные с директивой через документы) @bproces_of_directive = Bproce.last.bproces_of_directive(@directive.id)  # процессы, документы которых ссылаются на директиву
    Bproce.find_by_sql [ "select bproces.* from bproces, bproce_documents, document_directives
      where bproce_documents.bproce_id = bproces.id
      and document_directives.directive_id = ?
      and document_directives.document_id = bproce_documents.document_id
      group by bproces.id order by lft", directive_id ]
  end

end
