# encoding: utf-8
class Document < ActiveRecord::Base
  # FIXME разобраться со статусами на русском
  # STATUSES = %w[Проект Согласование Утвержден]
  # validates_inclusion_of :status, in: STATUSES
  attr_accessible :document_file
  attr_accessor :delete_file

  acts_as_taggable
  #acts_as_taggable_on :category

  before_validation { document_file.clear if delete_file == '1' }
  has_attached_file :document_file,
    :url  => "/store/:id.:ymd.:basename.:extension",
    :styles => { :pdf => "pdf" }, 
    :path => ":rails_root/public/store/:id.:ymd.:basename.:extension",
    :hash_secret => "BankPermBP1Step",
    :processors => [:convert_to_pdf]

  #after_document_file_post_process :copy_to_pdf
  after_post_process :copy_to_pdf

  #validates_attachment :document_file, :content_type => ["application/pdf", "application/odf", "application/msword", "plain/text"]
  #validates_attachment :document_file, :content_type => { :content_type => "application/pdf" }

  validates :name, :length => {:minimum => 10, :maximum => 200}
  validates :bproce_id, :presence => true # документ относится к процессу
  validates :dlevel, :numericality => {:less_than => 5, :greater_than => 0}
  validates :place, :presence => true   # документ должен иметь место хранения
  validates :owner_id, presence: true   # должен иметь ответственного

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  # документ относится к процессу
  belongs_to :bproce
  belongs_to :user
  belongs_to :owner, :class_name => 'User'
  has_many :directive, :through => :document_directive
  has_many :document_directive, :dependent => :destroy
  has_many :bproce, through: :bproce_documents
  has_many :bproce_documents, dependent: :destroy 

  attr_protected :uploaded_file # чтобы не было ошибки при массовом сохранении из params

  # удалим из имени файла коды пробелов и заменим обратные слэши на прямые
  before_save [:file_name_sanityze]
  after_save :copy_to_pdf

  def owner_name
    owner.try(:displayname)
  end

  def owner_name=(name)
    self.owner = User.find_by_displayname(name) if name.present?
  end

  def file_name_sanityze
    if !self.eplace.to_s.empty?  # если имя файла не пустое
      fname = self.eplace[(self.eplace.index('_1_Норма') - 1).. - 1]  # обрежем начало - путь шары
      fname = fname.gsub(/%20/, ' ')  # заменим %20 на пробел
      fname = fname.gsub('\\', '/')   # заменим обратные слэши Windows на нормальные
      fname = fname.gsub('__Внут', '_1_Внут')
      self.eplace = fname
    end
  end

  def file_name
    file_name_sanityze
    return self.eplace
  end

  def pdf_path
    if self.document_file
      extention = File.extname(self.document_file.path)
      if extention != ".pdf"
        pdf_path = self.document_file.path[0, self.document_file.path.length - extention.length] + '.pdf'  # путь к файлу PDF для просмотра
      else
        pdf_path = self.document_file.path
      end
    end
  end

  def pdf_url
    if self.document_file
      extention = File.extname(self.document_file.path)
      if extention != ".pdf"
        pdf_url = self.document_file.url.gsub(extention, ".pdf")  # url файла PDF для просмотра
      else
        pdf_url = self.document_file.url
      end
    end
  end

  def shortname
    return name.split(//u)[0..50].join
  end

  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ? or id = ? COLLATE NOCASE', "%#{search}%", "%#{search}%", "#{search}")
    else
      scoped
    end
  end

  private

  # интерполяция для paperclip - вернуть дату последней загрузки файла документа в формате ГГГГММДД
  Paperclip.interpolates :ymd do |attachment, style|
    attachment.instance_read(:updated_at).strftime('%Y%m%d')
  end
  
  def copy_to_pdf
    if valid?
      if delete_file == '1' # файл удаляется
      else
        if self.document_file_file_name?
          if File.exist?(document_file.path)
            Paperclip.run('unoconv', "-f pdf #{self.document_file.path}") if File.extname(self.document_file.path) != ".pdf"
          else
            puts "****** file not found " + self.document_file_file_name.to_s
          end
        end
      end
    end
  end

end
