class AddFieldToBproce < ActiveRecord::Migration[4.2]
  def change
    add_column :bproces, :description, :text
  end
end
