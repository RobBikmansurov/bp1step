class AddFieldsToWorkplace < ActiveRecord::Migration[4.2]
  def change
    add_column :workplaces, :switch, :string
    add_column :workplaces, :port, :integer
  end
end
