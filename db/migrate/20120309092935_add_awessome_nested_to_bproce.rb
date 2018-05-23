class AddAwessomeNestedToBproce < ActiveRecord::Migration[4.2]
  def change
    add_column :bproces, :parent_id, :integer, :null => true

    add_column :bproces, :lft, :integer
    add_column :bproces, :rgt, :integer
    add_column :bproces, :depth, :integer
  end
end
