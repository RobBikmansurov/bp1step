class AddFieldToBusinessRoles < ActiveRecord::Migration
  def change
    add_column :business_roles, :features, :text

  end
end
