class AddIndexToBproces < ActiveRecord::Migration
  def change
    add_index :bproces, :rgt
    add_index :bproces, :parent_id
    add_index :bproces, :lft
    add_index :bproces, :depth
  end
end
