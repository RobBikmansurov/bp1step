class DocumentDirective < ActiveRecord::Base
  validates :directive_id, :presence => true
  validates :document_id, :presence => true
  #TODO: как-то надо обеспечить контроль уникальности пар, пока это обеспечивается только индексом
  #validates [:document_id, :directive_id], :unique => true

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  belongs_to :directive
  belongs_to :document
end
