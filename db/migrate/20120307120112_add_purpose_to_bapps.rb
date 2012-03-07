class AddPurposeToBapps < ActiveRecord::Migration
  def change
    add_column :bapps, :purpose, :text
  end
end
