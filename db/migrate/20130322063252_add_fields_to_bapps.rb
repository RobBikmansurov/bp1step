class AddFieldsToBapps < ActiveRecord::Migration
  def change
    add_column :bapps, :version_app, :string
    add_column :bapps, :directory_app, :string
    add_column :bapps, :distribution_app, :string
    add_column :bapps, :executable_file, :string
    add_column :bapps, :licence, :string
    add_column :bapps, :source_app, :string
    add_column :bapps, :note, :text
  end
end
