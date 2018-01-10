class CreateTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :terms do |t|
      t.string :shortname
      t.string :name
      t.text :description
      t.text :note
      t.text :source

      t.timestamps null: false
    end
    add_index :terms, :shortname, :unique => true
    add_index :terms, :name, :unique => true
  end
end
