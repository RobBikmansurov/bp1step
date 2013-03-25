class CreateIresources < ActiveRecord::Migration
  def change
    create_table :iresources do |t|
      t.string :level
      t.string :label
      t.string :location
      t.string :alocation
      t.integer :volume
      t.text :note
      t.string :access_read
      t.string :access_write
      t.string :access_other
      t.references :user

      t.timestamps
    end
    add_index :iresources, :label, :unique => true
    add_index :iresources, :user_id
  end
end
