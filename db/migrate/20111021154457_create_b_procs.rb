class CreateBProcs < ActiveRecord::Migration
  def change
    create_table :b_procs do |t|
      t.string :ptitle
      t.text :pbody
      t.string :pcode

      t.timestamps
    end
  end
end
