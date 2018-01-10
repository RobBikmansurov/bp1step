class AddFieldToDirectivess < ActiveRecord::Migration[4.2]
  def change
    add_column :directives, :annotation, :text
  end
end
