class CreateAgentContracts < ActiveRecord::Migration[4.2]
  def change
    create_table :agent_contracts do |t|
      t.references :agent, index: true
      t.references :contract, index: true

      t.timestamps null: false
    end
  end
end
