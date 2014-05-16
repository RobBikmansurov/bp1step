class CreateBproceContracts < ActiveRecord::Migration
  def change
    create_table :bproce_contracts do |t|
      t.references :bproce, index: true
      t.references :contract, index: true
      t.string :purpose

      t.timestamps
    end
  end
end
