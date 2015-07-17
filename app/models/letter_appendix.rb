class LetterAppendix < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  default_scope { order(:name) }

  validates :letter_id, presence: true   # относится к письму
  validates :name, :presence => true,
                   :length => {:minimum => 3, :maximum => 255}
  
  belongs_to :letter

  has_attached_file :appendix,
    :url  => "/store/appendix/:id.:ymd.:basename.:extension",
    :presence  => false,
    :path => ":rails_root/public/store/appendix/:id.:ymd.:basename.:extension",
    :hash_secret => "BankPermBP1Step"
  validates :appendix, :attachment_presence => true
  do_not_validate_attachment_file_type :appendix  #paperclip >4.0
  validates_attachment_content_type :appendix, 
  :content_type => ['application/pdf', 'applications/vnd.pdf', 'binary/octet-stream',
                    'image/jpeg', 'image/gif', 'image/tiff',
                    'application/vnd.oasis.opendocument.text', 'application/vnd.oasis.opendocument.spreadsheet',
                    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                    'application/vnd.ms-excel', 'application/msword',
                    'application/doc', 'application/rtf',
                    'application/octet-stream', 'application/force-download']
  attr_accessible :letter_id, :name, :appendix

end