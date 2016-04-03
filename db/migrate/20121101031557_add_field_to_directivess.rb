class AddFieldToDirectivess < ActiveRecord::Migration
  def change
    add_column :directives, :annotation, :text
  end
end
