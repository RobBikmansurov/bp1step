class CreateBproceDocuments < ActiveRecord::Migration
  def change
    create_table :bproce_documents do |t|
      t.references :bproce
      t.references :document
      t.string :purpose

      t.timestamps
    end
    add_index :bproce_documents, :bproce_id
    add_index :bproce_documents, :document_id
  end
end
