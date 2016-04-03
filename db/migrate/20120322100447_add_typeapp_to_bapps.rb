class AddTypeappToBapps < ActiveRecord::Migration
  def change
    add_column :bapps, :apptype, :string
  end
end
