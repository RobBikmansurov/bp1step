class CreateBproceBapps < ActiveRecord::Migration[4.2]
  def change
    create_table :bproce_bapps do |t|
      t.integer :bproce_id
      t.integer :bapp_id

      t.timestamps null: false
    end
  end
end
