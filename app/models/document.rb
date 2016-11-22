# encoding: utf-8
class Document < ActiveRecord::Base

  belongs_to :user
  belongs_to :owner, :class_name => 'User'
  has_many :directive, :through => :document_directive
  has_many :document_directive, :dependent => :destroy
  has_many :bproce, through: :bproce_document
  has_many :bproce_document, dependent: :destroy
  has_many :user, through: :user_document
  has_many :user_document, dependent: :destroy

  attr_accessible :name, :dlevel, :description, :owner_name, :status, :approveorgan, :approved, 
                  :note, :place, :document_file, :file_delete, :bproce_id

  include PgSearch
  pg_search_scope :full_search, against: [
    [:name, 'A'],
    [:description, 'B'],
    :note, :id, :text
  ]

  scope :active, -> { where.not(status: 'НеДействует') } # действующие документы

  acts_as_taggable
  #acts_as_taggable_on :category

  #after_document_file_post_process :test
  after_save :copy_to_pdf

  #before_validation { document_file.clear if delete_file == '1' }
  has_attached_file :document_file,
    :url  => "/store/:id.:ymd.:basename.:extension",
    :presence  => false,
    :path => ":rails_root/public/store/:id.:ymd.:basename.:extension",
    :hash_secret => "BankPermBP1Step"
  validates :document_file, :attachment_presence => false
  do_not_validate_attachment_file_type :document_file  #paperclip >4.0
  validates_attachment_content_type :document_file,
                                    :content_type => ['application/pdf', 'applications/vnd.pdf', 'binary/octet-stream',
                                                      'application/vnd.oasis.opendocument.text', 'application/vnd.oasis.opendocument.spreadsheet',
                                                      'application/vnd.ms-excel', 'application/msword',
                                                      'application/doc', 'application/rtf',
                                                      'application/vnd.oasis.opendocument.graphics',
                                                      'application/octet-stream', 'application/force-download']
  validates :name, presence: true, length: {minimum: 10, maximum: 200}
  #validates :bproce_id, :presence => true # документ относится к процессу
  validates :dlevel, presence: true, numericality: {less_than: 5, greater_than: 0}
  validates :place, presence: true   # документ должен иметь место хранения
  validates :owner_id, presence: true   # должен иметь ответственного
  #validates :description, :length => {:maximum => 255}  # описание - не длиннее 255 символов

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, _model| controller.current_user }

  def owner_name
    owner.try(:displayname)
  end

  def owner_name=(name)
    self.owner = User.find_by_displayname(name) if name.present?
  end

  def pdf_path
    if self.document_file
      extention = File.extname(self.document_file.path)
      if extention != ".pdf"
        self.document_file.path[0, self.document_file.path.length - extention.length] + '.pdf'  # путь к файлу PDF для просмотра
      else
        self.document_file.path
      end
    end
  end

  def pdf_url
    if self.document_file
      extention = File.extname(self.document_file.path)
      if extention != ".pdf"
        self.document_file.url.gsub(extention, ".pdf")  # url файла PDF для просмотра
      else
        self.document_file.url
      end
    end
  end

  def shortname
    return name.split(//u)[0..50].join
  end

  private

  # интерполяция для paperclip - вернуть дату последней загрузки файла документа в формате ГГГГММДД
  Paperclip.interpolates :ymd do |attachment, _style|
    attachment.instance_read(:updated_at).strftime('%Y%m%d')
  end

  def copy_to_pdf
    if  self.document_file_file_name?  # задано имя файла
      if File.exist?(document_file.path)
        params = "-f pdf #{document_file.path}"
        begin
          Paperclip.run('unoconv', params)
        rescue
          puts 'error!'
        end
      else
        puts "***model/document.rb*** file not found #{self.document_file.path}"
      end
    end
  end

end
