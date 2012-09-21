class DocumentDirective < ActiveRecord::Base
  belongs_to :directive
  belongs_to :document
end
