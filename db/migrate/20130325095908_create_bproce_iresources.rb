class CreateBproceIresources < ActiveRecord::Migration
  def change
    create_table :bproce_iresources do |t|
      t.references :bproce
      t.references :iresource

      t.timestamps
    end
    add_index :bproce_iresources, :bproce_id
    add_index :bproce_iresources, :iresource_id
  end
end
