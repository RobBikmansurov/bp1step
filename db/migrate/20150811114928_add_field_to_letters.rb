class AddFieldToLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :letters, :in_out, :integer, :null => false, :default => 1
  end
end
