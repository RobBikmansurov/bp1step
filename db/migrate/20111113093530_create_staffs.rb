class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :fullname
      t.string :position
      t.boolean :supervisor

      t.timestamps
    end
  end
end
