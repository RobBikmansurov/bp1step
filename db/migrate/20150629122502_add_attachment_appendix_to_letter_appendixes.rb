class AddAttachmentAppendixToLetterAppendixes < ActiveRecord::Migration[4.2]
  def self.up
    change_table :letter_appendixes do |t|
      t.attachment :appendix
    end
  end

  def self.down
    remove_attachment :letter_appendixes, :appendix
  end
end
