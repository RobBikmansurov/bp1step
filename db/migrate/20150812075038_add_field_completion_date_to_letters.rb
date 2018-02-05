class AddFieldCompletionDateToLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :letters, :completion_date, :date
  end
end
