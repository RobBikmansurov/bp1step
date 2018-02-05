class AddFieldCheckedAtToBproces < ActiveRecord::Migration[4.2]
  def change
    add_column :bproces, :checked_at, :date
  end
end
