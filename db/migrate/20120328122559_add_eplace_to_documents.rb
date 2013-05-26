class AddEplaceToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :eplace, :string
    add_column :documents, :approveorgan, :string
    add_column :documents, :dlevel, :integer

    add_index :documents, :id,                :unique => true
  end
end
