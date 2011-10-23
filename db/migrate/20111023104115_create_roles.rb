class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.text :note
      t.references :b_proc

      t.timestamps
    end
    add_index :roles, :b_proc_id
  end
end
