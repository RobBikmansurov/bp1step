class AddStatusIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :status_id, :integer
  end
end
