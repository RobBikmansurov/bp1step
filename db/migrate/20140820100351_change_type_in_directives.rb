class ChangeTypeInDirectives < ActiveRecord::Migration
  def self.up
    change_column :directives, :name, :text
  end
 
  def self.down
    change_column :directives, :name, :string
  end
end
