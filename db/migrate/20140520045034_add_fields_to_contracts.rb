class AddFieldsToContracts < ActiveRecord::Migration[4.2]
  def change
    add_column :contracts, :condition, :text
    add_column :contracts, :check, :text
  end
end
