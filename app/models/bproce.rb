# frozen_string_literal: true

class Bproce < ApplicationRecord
  include TheSortableTree::Scopes
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  include PgSearch
  pg_search_scope :search__by_all_column,
                  against: %i[description goal id name fullname shortname],
                  using: { tsearch: { prefix: true } }

  acts_as_taggable

  validates :shortname, presence: true,
                        uniqueness: true,
                        length: { minimum: 1, maximum: 50 }
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 10, maximum: 250 }
  validates :fullname, length: { minimum: 10, maximum: 250 }

  acts_as_nested_set
  # attr_accessible :shortname, :name, :fullname, :goal, :description, :user_name,
  #                :parent_id, :parent_name, :tag_list, :tag_id, :context,
  #                :user_id, :taggable, :checked_at

  has_many :bapps, through: :bproce_bapps
  has_many :bproce_bapps, dependent: :destroy
  has_many :documents, through: :bproce_documents
  has_many :bproce_documents, dependent: :destroy
  has_many :bproce_iresource, dependent: :destroy
  has_many :bproce_workplaces, dependent: :destroy
  has_many :business_roles, dependent: :destroy
  has_many :bproce_contract, dependent: :destroy
  has_many :contracts, through: :bproce_contract
  has_many :iresource, through: :bproce_iresource
  has_many :workplaces, through: :bproce_workplaces
  has_many :metrics, dependent: :destroy
  belongs_to :bproce, foreign_key: 'parent_id', optional: true # родительский процесс # rubocop:disable Rails/InverseOf

  # has_many :parent_bp, class_name: 'Bproce', foreign_key: 'parent_id' # родительский процесс
  # belongs_to :parent, class_name: 'Bproce'
  belongs_to :user # владелец процессв

  def user_name
    user.try(:displayname)
  end

  def user_name=(name)
    self.user_id = User.find_by(displayname: name)&.id if name.present?
  end

  def parent_name
    parent&.try(:name)
  end

  def parent_name=(name)
    self.parent_id = Bproce.find_by(name: name)&.id if name.present?
  end

  # процессы директивы (все процессы, связанные с директивой через документы)
  def bproces_of_directive(directive_id)
    Bproce.find_by_sql(<<-SQL.squish)
      SELECT bproces.* from bproces, bproce_documents, document_directives
      WHERE bproce_documents.bproce_id = bproces.id
        and document_directives.directive_id = #{directive_id}
        and document_directives.document_id = bproce_documents.document_id
      GROUP BY bproces.id ORDER BY lft
    SQL
  end
end
