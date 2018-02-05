class ChangeFieldTypeInBusinessRoles < ActiveRecord::Migration[4.2]
  def self.up
    change_column :business_roles, :description, :text
  end
 
  def self.down
    change_column :business_roles, :description, :string
  end
end
