class AddIndexToDocuments < ActiveRecord::Migration
  def change
    add_index :document_directives, [:document_id, :directive_id], :unique => true
  end
end
