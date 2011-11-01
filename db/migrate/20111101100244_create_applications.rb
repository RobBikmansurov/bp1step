class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :app_name
      t.string :app_type
      t.string :app_note

      t.timestamps
    end
  end
end
