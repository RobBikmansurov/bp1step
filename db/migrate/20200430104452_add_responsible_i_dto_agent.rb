class AddResponsibleIDtoAgent < ActiveRecord::Migration[5.2]
  def change
    add_column :agents, :responsible_id, :integer, null: true
  end
end
