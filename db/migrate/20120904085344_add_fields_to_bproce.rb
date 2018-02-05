class AddFieldsToBproce < ActiveRecord::Migration[4.2]
  def change
    add_column :bproces, :user_id, :integer

  end
end
