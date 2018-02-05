class CreateDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :filename
      t.string :description
      t.string :status
      t.integer :status_id
      t.integer :owner_id
      t.string :part
      t.date :approved
      t.string :place

      t.timestamps null: false
    end
  end
end
