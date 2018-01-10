class CreateBusinessRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :business_roles do |t|
      t.string :name
      t.string :description
      t.references :bproce

      t.timestamps null: false
    end
    add_index :business_roles, :bproce_id
  end
end
