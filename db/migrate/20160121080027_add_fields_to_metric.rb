class AddFieldsToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :mtype, :string, limit: 10
    add_column :metrics, :msql, :text
    add_column :metrics, :mhash, :string, limit: 32
  end
end
