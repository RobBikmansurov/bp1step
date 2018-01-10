class ChangeLimitForColumnsInLetters < ActiveRecord::Migration[4.2]
  def self.up
    change_column :letters, :number, :string, limit: 30
    change_column :letters, :source, :string, limit: 20
  end
  def self.down
    change_column :letters, :number, :string, limit: 20
    change_column :letters, :source, :string, limit: 10
  end
end
