class AddFieldTextToDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :text, :text
  end
end
