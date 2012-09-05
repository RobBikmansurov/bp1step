class AddFieldsToBproce < ActiveRecord::Migration
  def change
    add_column :bproces, :user_id, :integer

  end
end
