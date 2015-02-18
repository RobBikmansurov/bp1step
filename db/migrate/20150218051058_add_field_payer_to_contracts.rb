class AddFieldPayerToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :payer_id, :integer
    add_index :contracts, :payer_id
  end
end
