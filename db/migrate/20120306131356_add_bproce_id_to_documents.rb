class AddBproceIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :bproce_id, :integer
  end
end
