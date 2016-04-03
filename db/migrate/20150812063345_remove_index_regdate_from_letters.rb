class RemoveIndexRegdateFromLetters < ActiveRecord::Migration
  def self.up
    add_index :letters, :regnumber
    remove_index :letters, :regdate
  end
  def self.down
    remove_index :letters, :regnumber
    add_index :letters, :regdate
  end
end
