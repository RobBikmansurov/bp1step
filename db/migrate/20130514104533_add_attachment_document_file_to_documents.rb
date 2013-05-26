class AddAttachmentDocumentFileToDocuments < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.attachment :document_file
    end
  end

  def self.down
    remove_attachment :documents, :document_file
  end
end
