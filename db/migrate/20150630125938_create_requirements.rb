class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :label
      t.date :date
      t.date :duedate
      t.string :source
      t.text :body
      t.integer :status
      t.text :result
      t.references :letter, index: true
      t.references :author, index: true

      t.timestamps null: false
    end
    add_index :requirements, :label
    add_index :requirements, :date
  end
end
