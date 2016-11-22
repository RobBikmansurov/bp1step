class CreateDirectives < ActiveRecord::Migration
  def change
    create_table :directives do |t|
      t.string :title
      t.string :number
      t.date :approval
      t.string :name
      t.string :note
      t.string :body

      t.timestamps null: false
    end
  end
end
