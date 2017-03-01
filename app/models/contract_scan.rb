# frozen_string_literal: true
class ContractScan < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  default_scope { order(:name) }

  validates :contract_id, presence: true # относится к контракту
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 255 }

  belongs_to :contract

  has_attached_file :scan,
                    url: '/store/scan/:id.:ymd.:basename.:extension',
                    presence: false,
                    path: ':rails_root/public/store/scan/:id.:ymd.:basename.:extension',
                    hash_secret: 'BankPermBP1Step'
  validates :scan, attachment_presence: true
  do_not_validate_attachment_file_type :scan # paperclip >4.0
  validates_attachment_content_type :scan,
                                    content_type: [
                                      'application/pdf', 'applications/vnd.pdf', 'binary/octet-stream',
                                      'image/jpeg', 'image/gif', 'image/tiff',
                                      'application/vnd.oasis.opendocument.text', 'application/vnd.oasis.opendocument.spreadsheet',
                                      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                      'application/vnd.ms-excel', 'application/msword',
                                      'application/doc', 'application/rtf',
                                      'application/octet-stream', 'application/force-download'
                                    ]
  attr_accessible :contract_id, :name, :scan
end
