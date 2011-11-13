class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :filename
      t.string :description
      t.string :status
      t.string :part
      t.date :approved
      t.string :place

      t.timestamps
    end
  end
end
