class DocumentDirective < ActiveRecord::Base
  validates :directive_id, :presence => true
  validates :document_id, :presence => true
  
  belongs_to :directive
  belongs_to :document
end
