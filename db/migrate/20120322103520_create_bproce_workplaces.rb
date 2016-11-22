class CreateBproceWorkplaces < ActiveRecord::Migration
  def change
    create_table :bproce_workplaces do |t|
      t.integer :bproce_id
      t.integer :workplace_id

      t.timestamps null: false
    end
  end
end
