class AddFieldStatusToDirectives < ActiveRecord::Migration[4.2]
  def change
    add_column :directives, :status, :string
  end
end
