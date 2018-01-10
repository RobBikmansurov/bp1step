class CreateBproceDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :bproce_documents do |t|
      t.references :bproce
      t.references :document
      t.string :purpose

      t.timestamps null: false
    end
    add_index :bproce_documents, :bproce_id
    add_index :bproce_documents, :document_id
  end
end
