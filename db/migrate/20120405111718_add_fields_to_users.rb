class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string

    add_column :users, :lastname, :string

    add_column :users, :username, :string

    add_column :users, :displayname, :string

  end
end
