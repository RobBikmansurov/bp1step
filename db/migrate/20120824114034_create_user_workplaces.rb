class CreateUserWorkplaces < ActiveRecord::Migration
  def change
    create_table :user_workplaces do |t|
      t.date :date_from
      t.date :date_to
      t.string :note
      t.references :user
      t.references :workplace

      t.timestamps null: false
    end
    add_index :user_workplaces, :user_id
    add_index :user_workplaces, :workplace_id
  end
end
