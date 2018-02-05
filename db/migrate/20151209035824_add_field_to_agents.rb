class AddFieldToAgents < ActiveRecord::Migration[4.2]
  def change
    add_column :agents, :note, :text
  end
end
