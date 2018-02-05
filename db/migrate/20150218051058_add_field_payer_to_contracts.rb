class AddFieldPayerToContracts < ActiveRecord::Migration[4.2]
  def change
    add_column :contracts, :payer_id, :integer
    add_index :contracts, :payer_id
  end
end
