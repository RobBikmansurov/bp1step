class CreateWorkplaces < ActiveRecord::Migration
  def change
    create_table :workplaces do |t|
      t.string :designation
      t.string :name
      t.string :description
      t.boolean :typical
      t.string :location

      t.timestamps null: false
    end
  end
end
