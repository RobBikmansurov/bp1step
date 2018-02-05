class CreateBapps < ActiveRecord::Migration[4.2]
  def change
    create_table :bapps do |t|
      t.string :name
      t.string :type
      t.string :description

      t.timestamps null: false
    end
  end
end
