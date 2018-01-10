class AddApurposeToBproceBapps < ActiveRecord::Migration[4.2]
  def change
    add_column :bproce_bapps, :apurpose, :text

  end
end
