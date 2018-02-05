class AddFieldToBusinessRoles < ActiveRecord::Migration[4.2]
  def change
    add_column :business_roles, :features, :text

  end
end
