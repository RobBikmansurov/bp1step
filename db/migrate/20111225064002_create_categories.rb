class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :cat_table
      t.string :cat_type
      t.string :cat_name
      t.integer :sortorder

      t.timestamps
    end
  end
end
