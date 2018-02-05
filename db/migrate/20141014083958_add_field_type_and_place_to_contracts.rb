class AddFieldTypeAndPlaceToContracts < ActiveRecord::Migration[4.2]
  def change
    add_column :contracts, :contract_type, :string
    add_column :contracts, :contract_place, :string
  end
end
