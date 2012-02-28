class AddBproceIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :bproce_id, :integer
  end
end
