# frozen_string_literal: true

class Directive < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  validates :approval, presence: true
  validates :number, presence: true
  validates :name, presence: true, length: { minimum: 10 }
  validates :body, length: { minimum: 2, maximum: 100 }	# орган, утвердивший документ
  validates :status, length: { maximum: 30 }
  validates :note, length: { maximum: 255 }

  has_many :document, through: :document_directive
  has_many :document_directive, dependent: :destroy

  # attr_accessible :name, :body, :number, :approval, :title, :annotation, :note, :status, :action

  def shortname
    if approval
      title + ' ' + number + ' от ' + approval.strftime('%d.%m.%Y')
    else
      title + ' ' + number
    end
  end

  def midname
    title + ' ' + body + ' №' + number + (approval ? ' ' + approval.strftime('%d.%m.%Y') : '')
  end

  # добавляет #id в конце строки
  def directive_name
    "#{midname}   ##{id}"
  end

  # возвращет directive.id из конца строки наименования
  def directive_name=(name)
    return if name.blank?
    i = name.rindex('#')
    #name.slice(i + 1, 5).to_i if i.positive?
    self.id = name[(i + 1..-1)].to_i
  end

  def directives_of_bproce(bproce_id) # все директивы процесса (связаны с ним через документы процесса)
    Directive.find_by_sql ["select directives.* from directives, document_directives, bproce_documents
      where bproce_documents.bproce_id = ?
      and bproce_documents.document_id = document_directives.document_id
      and directives.id = document_directives.directive_id
      group by directives.id", bproce_id]
  end

  def self.search(search)
    return where(nil) if search.blank?

    where('number ILIKE ? or name ILIKE ? or title ILIKE ? or body ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
