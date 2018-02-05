class CreateDocumentDirectives < ActiveRecord::Migration[4.2]
  def change
    create_table :document_directives do |t|
      t.references :document
      t.references :directive
      t.string :note

      t.timestamps null: false
    end
  end
end
