class DocumentDirective < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  validates :directive_id, :presence => true
  validates :document_id, :presence => true
  #TODO: как-то надо обеспечить контроль уникальности пар, пока это обеспечивается только индексом
  #validates [:document_id, :directive_id], :unique => true

  belongs_to :directive
  belongs_to :document

  attr_accessible :directive_id, :document_id

end
