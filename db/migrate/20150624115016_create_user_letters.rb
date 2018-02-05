class CreateUserLetters < ActiveRecord::Migration[4.2]
  def change
    create_table :user_letters do |t|
      t.references :user, index: true
      t.references :letter, index: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
