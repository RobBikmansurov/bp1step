class AddFieldToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :note, :text
  end
end
