class CreateAgents < ActiveRecord::Migration[4.2]
  def change
    create_table :agents do |t|
      t.string :name, limit: 255
      t.string :town, limit: 30
      t.string :address, limit: 255
      t.text :contacts

      t.timestamps null: false
    end
  end
end
