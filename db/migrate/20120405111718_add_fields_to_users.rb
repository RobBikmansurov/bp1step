class AddFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :firstname, :string

    add_column :users, :lastname, :string

    add_column :users, :username, :string

    add_column :users, :displayname, :string

  end
end
