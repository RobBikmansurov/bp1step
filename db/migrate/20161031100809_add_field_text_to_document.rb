class AddFieldTextToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :text, :text
  end
end
