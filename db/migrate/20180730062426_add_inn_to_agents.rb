class AddInnToAgents < ActiveRecord::Migration[5.2]
  def change
    add_column :agents, :inn, :string, limit: 12
    add_column :agents, :dms_name, :string
  end
end
