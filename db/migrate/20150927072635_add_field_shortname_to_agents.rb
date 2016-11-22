class AddFieldShortnameToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :shortname, :string, limit: 30
  end
end
