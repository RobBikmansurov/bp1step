class CreateBusinessRoles < ActiveRecord::Migration
  def change
    create_table :business_roles do |t|
      t.string :name
      t.string :description
      t.references :bproce

      t.timestamps
    end
    add_index :business_roles, :bproce_id
  end
end
