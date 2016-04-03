class AddFieldToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :in_out, :integer, :null => false, :default => 1
  end
end
