class CreateUserDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :user_documents do |t|
      t.references :user, index: true
      t.references :document, index: true
      t.integer :link

      t.timestamps null: false
    end
  end
end
