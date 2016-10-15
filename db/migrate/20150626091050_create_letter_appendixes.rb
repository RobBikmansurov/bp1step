class CreateLetterAppendixes < ActiveRecord::Migration
  def change
    create_table :letter_appendixes do |t|
      t.references :letter, index: true
      t.string :name

      t.timestamps null: false
    end
  end
end
