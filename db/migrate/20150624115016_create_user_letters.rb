class CreateUserLetters < ActiveRecord::Migration
  def change
    create_table :user_letters do |t|
      t.references :user, index: true
      t.references :letter, index: true
      t.integer :status

      t.timestamps
    end
  end
end
