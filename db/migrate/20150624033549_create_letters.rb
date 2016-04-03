class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.string :regnumber, limit: 10
      t.date :regdate
      t.string :number, limit: 20
      t.date :date
      t.string :subject, limit: 200
      t.string :source, limit: 10
      t.text :sender
      t.text :body
      t.date :duedate
      t.integer :status
      t.text :result
      t.references :letter, index: true

      t.timestamps
    end
    add_index :letters, :regdate, unique: true
    add_index :letters, :number
    add_index :letters, :date
  end
end
