class ChangeFieldTypeInDocuments < ActiveRecord::Migration[4.2]
  def self.up
    change_column :documents, :description, :text
  end
 
  def self.down
    change_column :documents, :description, :string
  end
end
