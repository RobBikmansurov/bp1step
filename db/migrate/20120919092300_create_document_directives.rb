class CreateDocumentDirectives < ActiveRecord::Migration
  def change
    create_table :document_directives do |t|
      t.references :document
      t.references :directive
      t.string :note

      t.timestamps
    end
  end
end
