class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, limit: 255
      t.text :description
      t.date :duedate
      t.text :result
      t.integer :status
      t.text :result
      t.date :completion_date
      t.references :letter, index: true, foreign_key: true
      t.references :requirement, index: true, foreign_key: true
      t.references :author, index: true

      t.timestamps null: false
    end
    add_index :tasks, :name, unique: true
    add_index :tasks, :duedate
  end
end
