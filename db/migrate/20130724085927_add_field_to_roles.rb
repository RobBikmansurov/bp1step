class AddFieldToRoles < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :note, :string
  end
end
