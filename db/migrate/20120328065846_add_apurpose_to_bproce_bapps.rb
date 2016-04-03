class AddApurposeToBproceBapps < ActiveRecord::Migration
  def change
    add_column :bproce_bapps, :apurpose, :text

  end
end
