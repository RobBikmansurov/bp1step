class CreateMetrics < ActiveRecord::Migration[4.2]
  def change
    create_table :metrics do |t|
      t.references :bproce, index: true
      t.string :name, limit: 200
      t.string :shortname, limit: 30
      t.text :description
      t.text :note
      t.integer :depth

      t.timestamps null: false
    end
  end
end
