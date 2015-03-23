class CreateUserDocuments < ActiveRecord::Migration
  def change
    create_table :user_documents do |t|
      t.references :user, index: true
      t.references :document, index: true
      t.integer :link

      t.timestamps
    end
  end
end
