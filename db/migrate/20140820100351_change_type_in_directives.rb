class ChangeTypeInDirectives < ActiveRecord::Migration[4.2]
  def self.up
    change_column :directives, :name, :text
  end
 
  def self.down
    change_column :directives, :name, :string
  end
end
