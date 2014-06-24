class AddAwessomeNestedToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :parent_id, :integer
    add_index :contracts, :parent_id
    add_column :contracts, :lft, :integer
    add_column :contracts, :rgt, :integer
    add_index :contracts, :rgt
    add_column :contracts, :depth, :integer
  end
end
