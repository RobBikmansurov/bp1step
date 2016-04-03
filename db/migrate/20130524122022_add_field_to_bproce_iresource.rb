class AddFieldToBproceIresource < ActiveRecord::Migration
  def change
    add_column :bproce_iresources, :rpurpose, :text
  end
end
