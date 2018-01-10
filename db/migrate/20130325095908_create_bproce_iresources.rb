class CreateBproceIresources < ActiveRecord::Migration[4.2]
  def change
    create_table :bproce_iresources do |t|
      t.references :bproce
      t.references :iresource

      t.timestamps null: false
    end
    add_index :bproce_iresources, :bproce_id
    add_index :bproce_iresources, :iresource_id
  end
end
