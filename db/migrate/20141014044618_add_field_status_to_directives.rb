class AddFieldStatusToDirectives < ActiveRecord::Migration
  def change
    add_column :directives, :status, :string
  end
end
