class CreateBproceContracts < ActiveRecord::Migration[4.2]
  def change
    create_table :bproce_contracts do |t|
      t.references :bproce, index: true
      t.references :contract, index: true
      t.string :purpose

      t.timestamps null: false
    end
  end
end
