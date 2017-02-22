# frozen_string_literal: true
class LetterAppendix < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller.current_user }

  default_scope { order(:name) }

  has_attached_file :appendix,
                    url: '/store/appendix/:id.:basename.:extension',
                    path: ':rails_root/public/store/appendix/:id.:basename.:extension',
                    hash_secret: 'BankPermBP1Step'
  validates :appendix, attachment_presence: true, validate_media_type: false

  validates_attachment_content_type :appendix,
                                    content_type: ['application/pdf',
                                                   'application/vnd.pdf',
                                                   /\Aimage/,
                                                   /\Aapplication/]
  # validates_attachment_file_name :appendix, :matches => [/png\Z/, /jpe?g\Z/, /pdf\Z/]
  # validates_attachment_file_name :appendix, matches: [/\.(pdf|(docx?)|dot|wrd)\z/]
  do_not_validate_attachment_file_type :appendix

  validates :letter_id, presence: true # относится к письму
  # validates :name, :presence => true, :length => {:minimum => 3, :maximum => 255}

  belongs_to :letter

  attr_accessible :letter_id, :name, :appendix
end
