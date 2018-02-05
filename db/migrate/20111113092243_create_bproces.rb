class CreateBproces < ActiveRecord::Migration[4.2]
  def change
    create_table :bproces do |t|
      t.string :shortname
      t.string :name
      t.string :fullname

      t.timestamps null: false
    end
  end
end
