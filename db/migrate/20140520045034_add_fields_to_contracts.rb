class AddFieldsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :condition, :text
    add_column :contracts, :check, :text
  end
end
