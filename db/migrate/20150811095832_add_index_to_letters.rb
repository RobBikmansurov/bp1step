class AddIndexToLetters < ActiveRecord::Migration
  def change
    add_index :letters, :status
  end
end
