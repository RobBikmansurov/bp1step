class AddIndexToLetters < ActiveRecord::Migration[4.2]
  def change
    add_index :letters, :status
  end
end
