class AddBproceIdToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :bproce_id, :integer
  end
end
