class AddAwessomeNestedToBproce < ActiveRecord::Migration
  def change
    add_column :bproces, :parent_id, :integer
    add_column :bproces, :lft, :integer
    add_column :bproces, :rgt, :integer
    add_column :bproces, :depth, :integer
  end
end
