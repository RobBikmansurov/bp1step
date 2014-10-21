class AddFieldShortnameToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :shortname, :string
  end
end
