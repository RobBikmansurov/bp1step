class AddFieldToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :note, :string
  end
end
