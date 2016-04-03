class CreateBproces < ActiveRecord::Migration
  def change
    create_table :bproces do |t|
      t.string :shortname
      t.string :name
      t.string :fullname

      t.timestamps
    end
  end
end
