class AddFieldTypeAndPlaceToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :contract_type, :string
    add_column :contracts, :contract_place, :string
  end
end
