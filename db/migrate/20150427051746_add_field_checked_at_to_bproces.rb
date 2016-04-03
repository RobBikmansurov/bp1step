class AddFieldCheckedAtToBproces < ActiveRecord::Migration
  def change
    add_column :bproces, :checked_at, :date
  end
end
