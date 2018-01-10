class AddTypeappToBapps < ActiveRecord::Migration[4.2]
  def change
    add_column :bapps, :apptype, :string
  end
end
