class CreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
	  t.integer :bproce_id
      t.timestamps null: false
    end
  end
end
