class AddPurposeToBapps < ActiveRecord::Migration[4.2]
  def change
    add_column :bapps, :purpose, :text
  end
end
