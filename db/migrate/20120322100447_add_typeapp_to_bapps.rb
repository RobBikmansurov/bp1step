class AddTypeappToBapps < ActiveRecord::Migration
  def change
    add_column :bapps, :apptype, :string
    remove_column :bapps, :type
  end
end
