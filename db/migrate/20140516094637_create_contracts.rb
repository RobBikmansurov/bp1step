class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :owner, index: true
      t.string :number, limit: 20
      t.string :name, limit: 255
      t.string :status, limit: 30
      t.date :date_begin
      t.date :date_end
      t.text :description
      t.text :text
      t.text :note

      t.timestamps
    end
  end
end
