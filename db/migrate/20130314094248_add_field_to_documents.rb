class AddFieldToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :note, :string
  end
end
