# frozen_string_literal: true

class DocumentDirective < ApplicationRecord
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :directive_id, presence: true
  validates :document_id, presence: true
  # TODO: как-то надо обеспечить контроль уникальности пар, пока это обеспечивается только индексом
  # validates [:document_id, :directive_id], :unique => true

  belongs_to :directive
  belongs_to :document

  # attr_accessible :directive_id, :document_id, :note, :directive_number, :document_name

  def directive_number
    directive.try(:name)
  end

  def directive_number=(name)
    return if name.blank?

    i = name.rindex('#') #  id директивы передадвали в конце наименования директивы - см. model/directive.rb: directive_name
    self.directive_id = name.slice(i + 1, 5).to_i if i.positive?
  end

  def document_name
    document.try(:name)
  end

  def document_name=(name)
    self.document = Document.find_by(name: name) if name
  end
end
