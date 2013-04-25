class AddFieldToBproce < ActiveRecord::Migration
  def change
    add_column :bproces, :description, :text
  end
end
