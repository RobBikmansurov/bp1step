class AddFieldToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :note, :string
  end
end
