class AddFieldActionToDirectives < ActiveRecord::Migration
  def change
    add_column :directives, :action, :text
  end
end
