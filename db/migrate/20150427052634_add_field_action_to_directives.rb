class AddFieldActionToDirectives < ActiveRecord::Migration[4.2]
  def change
    add_column :directives, :action, :text
  end
end
