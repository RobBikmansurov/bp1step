class AddFieldsToDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :responsible, :integer

  end
end
