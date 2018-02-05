class CreateUserBusinessRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :user_business_roles do |t|
      t.date :date_from
      t.date :date_to
      t.string :note
      t.references :user, :null => false
      t.references :business_role, :null => false

      t.timestamps null: false
    end
    add_index :user_business_roles, :user_id
    add_index :user_business_roles, :business_role_id
    #add_index :user_business_roles, :user_id, :business_role_id, :unique => true
  end
end
