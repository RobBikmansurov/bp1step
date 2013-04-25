class AddFieldsToWorkplace < ActiveRecord::Migration
  def change
    add_column :workplaces, :switch, :string
    add_column :workplaces, :port, :integer
  end
end
