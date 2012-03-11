class CreateBproceBapps < ActiveRecord::Migration
  def change
    create_table :bproce_bapps do |t|
      t.integer :bproce_id
      t.integer :bapp_id

      t.timestamps
    end
  end
end
