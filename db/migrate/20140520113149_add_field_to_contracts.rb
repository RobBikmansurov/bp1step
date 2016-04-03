class AddFieldToContracts < ActiveRecord::Migration
  def change
    add_reference :contracts, :agent, index: true
  end
end
