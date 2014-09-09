class ChangeFieldTypeInBusinessRoles < ActiveRecord::Migration
  def self.up
    change_column :business_roles, :description, :text
  end
 
  def self.down
    change_column :business_roles, :description, :string
  end
end
