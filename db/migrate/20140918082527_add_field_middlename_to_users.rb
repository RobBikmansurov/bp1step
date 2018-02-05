class AddFieldMiddlenameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :middlename, :string
  end
end
