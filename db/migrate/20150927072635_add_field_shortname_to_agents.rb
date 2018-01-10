class AddFieldShortnameToAgents < ActiveRecord::Migration[4.2]
  def change
    add_column :agents, :shortname, :string, limit: 30
  end
end
