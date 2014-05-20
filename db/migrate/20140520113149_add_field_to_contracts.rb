class AddFieldToContracts < ActiveRecord::Migration
  def change
    add_reference :contracts, :agent_id, index: true
  end
end
