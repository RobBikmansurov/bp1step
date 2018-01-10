class AddIndexToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_index :document_directives, [:document_id, :directive_id], :unique => true
  end
end
