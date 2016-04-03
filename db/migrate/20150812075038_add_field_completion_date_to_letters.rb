class AddFieldCompletionDateToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :completion_date, :date
  end
end
