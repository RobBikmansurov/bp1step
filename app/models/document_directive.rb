class DocumentDirective < ActiveRecord::Base
  validates :directive_id, :presence => true
  validates :document_id, :presence => true
  #TODO: как-то надо обеспечить контроль уникальности пар, пока это обеспечивается только индексом
  #validates [:document_id, :directive_id], :unique => true
  
  belongs_to :directive
  belongs_to :document
end
