class CreateContractScans < ActiveRecord::Migration[4.2]
  def change
    create_table :contract_scans do |t|
      t.string :name
      t.references :contract, index: true

      t.timestamps null: false
    end
  end
end
