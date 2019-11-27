class AddUserToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :executor_id, :integer
    add_column :orders, :manager_id, :integer
  end
end
