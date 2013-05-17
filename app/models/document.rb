# encoding: utf-8
class Document < ActiveRecord::Base
  # FIXME разобраться со статусами на русском
  # TODO добавить конфиги для константы "_1_Норма" - начало пути шары для удаления OS-чувствительного маппинга шар (Windows - I:\, Linux - smb://)
  # STATUSES = %w[Проект Согласование Утвержден]
  # validates_inclusion_of :status, in: STATUSES
  attr_accessible :document_file
  has_attached_file :document_file,
    :url  => "/store/:id.:basename.:extension",
    :path => ":rails_root/public/store/:id.:basename.:extension",
    :hash_secret => "BankPerm"

  #validates_attachment :document_file, :content_type => ["application/pdf", "application/odf", "application/msword", "plain/text"]
  #validates_attachment :document_file, :content_type => { :content_type => "application/pdf" }

  validates :name, :length => {:minimum => 10, :maximum => 200}
  validates :bproce_id, :presence => true # документ относится к процессу
  validates :dlevel, :numericality => {:less_than => 5, :greater_than => 0}
  validates :place, :presence => true   # документ должен иметь место хранения
  validates :part, :presence => true   # документ должен иметь раздел документооборота

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  # документ относится к процессу
  belongs_to :bproce
  belongs_to :user
  belongs_to :owner, :class_name => 'User'
  has_many :directive, :through => :document_directive
  has_many :document_directive, :dependent => :destroy

  attr_protected :uploaded_file # чтобы не было ошибки при массовом сохранении из params

  # удалим из имени файла коды пробелов и заменим обратные слэши на прямые
  before_save :file_name_sanityze

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

  def shortname
    return name.split(//u)[0..50].join
  end

  def self.search(search)
    if search
      where('name LIKE ? or description LIKE ? or id LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
end
