class AddFieldToContracts < ActiveRecord::Migration[4.2]
  def change
    add_reference :contracts, :agent, index: true
  end
end
