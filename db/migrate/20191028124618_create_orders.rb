class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :order_type, null:false
      t.integer :codpred
      t.text :client_name
      t.references :author, index: true
      t.string :contract_number
      t.date :contract_date
      t.date :order_date
      t.date :due_date
      t.date :completed_at
      t.string :status
      t.text :result

      t.timestamps
    end
  end
end
