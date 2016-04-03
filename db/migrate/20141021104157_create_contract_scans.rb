class CreateContractScans < ActiveRecord::Migration
  def change
    create_table :contract_scans do |t|
      t.string :name
      t.references :contract, index: true

      t.timestamps
    end
  end
end
