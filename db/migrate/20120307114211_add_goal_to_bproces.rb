class AddGoalToBproces < ActiveRecord::Migration
  def change
    add_column :bproces, :goal, :text
  end
end
