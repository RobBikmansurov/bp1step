class CreateAgentContracts < ActiveRecord::Migration
  def change
    create_table :agent_contracts do |t|
      t.references :agent, index: true
      t.references :contract, index: true

      t.timestamps
    end
  end
end
