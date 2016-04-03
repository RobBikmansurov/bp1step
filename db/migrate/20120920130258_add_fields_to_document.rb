class AddFieldsToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :responsible, :integer

  end
end
