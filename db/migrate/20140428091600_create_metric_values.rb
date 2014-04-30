class CreateMetricValues < ActiveRecord::Migration
  def change
    create_table :metric_values do |t|
      t.references :metric, index: true
      t.datetime :dtime
      t.text :value, limit: 20

      t.timestamps
    end
  end
end
