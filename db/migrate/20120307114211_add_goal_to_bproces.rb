class AddGoalToBproces < ActiveRecord::Migration[4.2]
  def change
    add_column :bproces, :goal, :text
  end
end
