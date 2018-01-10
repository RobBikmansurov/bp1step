class Add3FieldsToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :department, :string
    add_column :users, :position, :string
    add_column :users, :office, :string
    add_column :users, :phone, :string
  end

  def down
    remove_column :users, :department
    remove_column :users, :position
    remove_column :users, :office
    remove_column :users, :phone
  end
end
